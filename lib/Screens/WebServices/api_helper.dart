import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseHelper {
  //String aPPmAINuRL = "https://admin.astropush.com/";
  //String aPPmAINuRL = "https://api.astrogurujii.com/";
  String aPPmAINuRL = "https://admin.astrogurujii.com/";
 // String aPPmAINuRL = "http://15.206.212.188:4000/";

  _authFailure() {}

  Future<dynamic> get(String url, Map reqBody) async {
    var responseJson;
    final response = await http.get(Uri.parse(aPPmAINuRL + url));
    responseJson = _returnResponse(response);
    // print("==="+jsonEncode(responseJson));
    try {} catch (e) {
      responseJson = null;
    }
    return responseJson;
  }

  Future<dynamic> getBearer(String url, String token) async {
    final _prefs = await SharedPreferences.getInstance();
    // print("fhghfkghkhfgkhfkghkfdhgkhdfghkdfhg=${_prefs.get('token')}");
    var responseJson;
     debugPrint("Url==>" + aPPmAINuRL + url);
     print("token");
     print(token);
    final response = await http.get(
      Uri.parse(aPPmAINuRL + url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
    );
    responseJson = _returnResponse(response);
    // print("===" + jsonEncode(responseJson));
    try {} catch (e) {
      responseJson = null;
    }
    return responseJson;
  }

  getCountryCode() async {
    return "INR";
    /*final response = await http.get(Uri.parse('http://ip-api.com/json'));
    Map data = jsonDecode(response.body);
    String country = data['country'];
    if (country == "India") {
      return "INR";
    } else {
      return "USD";
    }*/
  }

  Future<dynamic> put(String url, Map reqBody, String token) async {
    var responseJson;
    /* debugPrint("data==>" + reqBody.toString(), wrapWidth: 1024);
    debugPrint("data==>" + aPPmAINuRL + url);*/
    final response = await http
        .put(Uri.parse(aPPmAINuRL + url), body: jsonEncode(reqBody), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    //debugPrint("data==>" + response.body, wrapWidth: 1024);
    responseJson = _returnResponse(response);
    return responseJson;
    try {} catch (e) {
      print("===" + e.toString());
      e.toString();
    }
  }

  Future<dynamic> postBearer(String url, Map reqBody, String token) async {
    var responseJson;
    debugPrint("data==>" + reqBody.toString(), wrapWidth: 1024);
    debugPrint("Url==>" + aPPmAINuRL + url);
    print("token");
    print(token);
    final response = await http
        .post(Uri.parse(aPPmAINuRL + url), body: jsonEncode(reqBody), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    debugPrint("Responsefff=====>" + response.body, wrapWidth: 1024);
    responseJson = _returnResponse(response);
    return responseJson;
  }
  Future<dynamic> postBearerHoro(String url, Map reqBody) async {
    var responseJson;

    try {
      debugPrint("data==>" + reqBody.toString(), wrapWidth: 1024);
      debugPrint("url---->>>>>>>>>>" + aPPmAINuRL + url);
      final response = await http.post(
          Uri.parse("${aPPmAINuRL}user_api/get_daily_sun_horoscope"),
          body: jsonEncode(reqBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      responseJson = _returnResponse(response);
      debugPrint("data==>" + response.body, wrapWidth: 1024);
      return responseJson;
    } catch (e) {
      // print("=888=="+e.toString());
      e.toString();
    }
  }


  Future<dynamic> post(String url, Map reqBody) async {
    var responseJson;
    debugPrint("data==>" + reqBody.toString(), wrapWidth: 1024);
    debugPrint("data==>" + aPPmAINuRL + url);

    final response = await http.post(Uri.parse(aPPmAINuRL + url),
        body: jsonEncode(reqBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    debugPrint("data==>" + response.body, wrapWidth: 1024);
    responseJson = _returnResponse(response);
    return responseJson;
    try {} catch (e) {
      print("===" + e.toString());
      e.toString();
    }
  }

  Future<dynamic> postN(Map reqBody, String url) async {
    print("hello1.2");
    var responseJson;
     print("reqBody===>>>>  ${reqBody}");
     print("url===>>>>  ${url}");
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(reqBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print("hello1.3");

    responseJson = _returnResponse(response);
    print("hello1.4");

    print("Response=====>>>> ${responseJson}");

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 404:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 403:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        _authFailure();
        return null;
      default:
        return null;
    }
  }

  Future<dynamic> getGoogleMap(String url) async {
    //debugPrint("data==>" + url.toString(), wrapWidth: 1024);

    var responseJson;
    final response = await http.get(Uri.parse(url));
    //debugPrint("data==>" + response.body, wrapWidth: 1024);
    responseJson = _returnResponse(response);
    return responseJson;
  }
}
