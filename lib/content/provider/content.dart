// Packages and Libraries
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../../config//httpexception.dart';
import '../../config/config.dart' as config;

// Config and Providers
// import '../../Config/Config.dart' as config;
// import '../../Config/HttpException.dart';

class Content with ChangeNotifier {
  final String? _token;

  Content(this._token);

  Future<List<dynamic>> getSubscription() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(Uri.parse(config.pre_url_subscription),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      // print(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse["data"];
    } catch (error) {
      print(error);
      // print(responseCode);
      rethrow;
    }
  }

  Future<List<dynamic>> getQuickLinks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      Uri uri = Uri.parse(config.pre_url_ads);
      final finalUri = uri.replace(queryParameters: {'type': 'link'});
      var response = await http.get(finalUri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      print(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse["data"];
    } catch (error) {
      print(error);
      // print(responseCode);
      rethrow;
    }
  }

  Future<List<dynamic>> getAds() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      Uri uri = Uri.parse(config.pre_url_ads);
      final finalUri = uri.replace(queryParameters: {'type': 'ads'});
      var response = await http.get(finalUri,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      print(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse["data"];
    } catch (error) {
      print(error);
      // print(responseCode);
      rethrow;
    }
  }
}
