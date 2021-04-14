import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:io';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'dart:convert';

import 'Src/API.dart';

class HomePage extends StatefulWidget {
  final String phone;
  HomePage({this.phone});
  @override
  _WebViewWebPageState createState() => _WebViewWebPageState();
}

class _WebViewWebPageState extends State<HomePage> {
  StreamSubscription<HardwareButtons.VolumeButtonEvent>
      _volumeButtonSubscription;

  void initState() {
    super.initState();
          getData();

    _volumeButtonSubscription =
        HardwareButtons.volumeButtonEvents.listen((event) {
      print("button");
      _callNumber();
    });
    _requestPermission();
  }

  String phone;

  Future getData() async {
    final http.Response response = await CallApi().getData('data');
   // print(response.statusCode);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      //print(body);
      setState(() {
        phone = body['phone'];
      });
    }
  }


  _callNumber() async {

    String number = '+39$phone';
    print(number);
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
    //set the number here
  }

  bool sidebar = false;


  Future<bool> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      Permission.phone,

    ].request();
  }


  Future<bool> _onBack() async {
    bool goBack;
    var value = await webView.canGoBack();
    if (value) {
      webView.goBack();
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Confirmation ',
              style: TextStyle(color: Colors.orangeAccent)),
          // Are you sure?
          content: new Text('Do you want exit app ? '),
          // Do you want to go back?
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  goBack = false;
                });
              },
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  goBack = true;
                });
              },
              child: new Text('Yes'), // Yes
            ),
          ],
        ),
      );
      if (goBack) Navigator.pop(context); // If user press Yes pop the page
      return goBack;
    }
  }

  Future<void> _refresh() async {
    webView.reload();
  }

  var URL = "https://motionapp.website/";
  double progress = 0;
  InAppWebViewController webView;

  WebViewPlusController _controller;
  double _height = 1000;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: SafeArea(
        child: Scaffold(
         // resizeToAvoidBottomInset: false,
          body:
         // WebViewPlus(
         //    initialUrl: 'assets/index.html',
         //    onWebViewCreated: (controller) {
         //      this._controller = controller;
         //    },
         //    onPageFinished: (url) {
         //      _controller.getHeight().then((double height) {
         //        print("Height: " + height.toString());
         //        setState(() {
         //          _height = height;
         //        });
         //      });
         //    },
         //    javascriptMode: JavascriptMode.unrestricted,
         //  ),
          Container(

              child: Column(
                  children: <Widget>[
            (progress != 1.0)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.redAccent)),
                      // Container(
                      //        height: _height / 1.1365,
                      //        width: _width,
                      //        child:
                      //            Center(child: Image.asset('assets/splash.png')))
                    ],
                  )
                : null, //
            // Should be removed while showing
            Expanded(
              child: Container(
                child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse("http://localhost:8080/assets/index.html")
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        useShouldOverrideUrlLoading: true,

                        mediaPlaybackRequiresUserGesture: false,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },

                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },

              ),
            ))
          ].where((Object o) => o != null).toList())),
        ),
      ),
    ); //Remove null widgets
  }
}
