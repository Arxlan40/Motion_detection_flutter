import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

/// -----------------------------------------
/// calling Api class
/// -----------------------------------------

class CallApi {
  final String _url = 'https://motionapp.website/api/';

 

  /// -----------------------------------------
  /// getting data from api function
  /// -----------------------------------------

  getData(apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
            print(fullUrl);

      return await http.get(Uri.parse(fullUrl));
    } catch (e) {
      Fluttertoast.showToast(timeInSecForIosWeb: 3, msg: "error");
    }
  }


  /// -----------------------------------------
  /// headers
  /// -----------------------------------------


  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
