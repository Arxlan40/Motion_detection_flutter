// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import 'Src/API.dart';
// import 'home.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//
//   /// -----------------------------------------
//   /// Initstate and timer for splash screen
//   /// -----------------------------------------
//
//   void initState() {
//     super.initState();
//     getData();
//   }
//
//   void startTimer(String phone) {
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => HomePage(phone: phone,)));
//     });
//   }
//
//   Future getData() async {
//     final http.Response response = await CallApi().getData('data');
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       var body = json.decode(response.body);
//
//
//       startTimer(body['phone']);
//     }
//
//   }
//
//   double _height;
//   double _width;
//   @override
//   Widget build(BuildContext context) {
//     _height = MediaQuery.of(context).size.height;
//     _width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           height: _height / 1.1365,
//           width: _width,
//           color: Colors.black,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.asset(
//               'assets/splash.png',
//             ),
//           ),
//         ));
//   }
// }
