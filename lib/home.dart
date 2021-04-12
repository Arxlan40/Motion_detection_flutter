import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_incall/flutter_incall.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:io';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      setState(() {
        phone = body['phone'];
      });
    }
  }

  IncallManager incallManager = new IncallManager();

  _callNumber() async {
    incallManager.setSpeakerphoneOn(true);

    String number = '+39$phone';
    print(number);
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
    //set the number here
  }

  bool sidebar = false;

  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission() async {
    var result = await _permissionHandler.requestPermissions([
      PermissionGroup.microphone,
      PermissionGroup.camera,
      PermissionGroup.accessMediaLocation,
      PermissionGroup.camera,
    ]);
  }

  Future<bool> requestPermission({Function onPermissionDenied}) async {
    Future<bool> hasPermission(PermissionGroup permission) async {
      var permissionStatus =
          await _permissionHandler.checkPermissionStatus(permission);
      return permissionStatus == PermissionStatus.granted;
    }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
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
                  initialUrl: URL,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      mediaPlaybackRequiresUserGesture: false,
                      debuggingEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart:
                      (InAppWebViewController controller, String url) {},
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      sidebar = true;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  }),
            ),
          )
        ].where((Object o) => o != null).toList())),
      ),
    ); //Remove null widgets
  }
}
