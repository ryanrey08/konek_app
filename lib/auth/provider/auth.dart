// Packages and Libraries
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Config and Providers
// import '../../Config/Config.dart' as config;
// import '../../Config/HttpException.dart';

class Auth with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return '';
  }

  // Future<void> login(String contact_number, String password) async {
  //   Map data = {'contact_number': contact_number, 'password': password};
  //   Map<String, dynamic> jsonResponse;
  //   var responseCode;
  //   try {
  //     var response = await http.post(config.pre_url + config.auth_route + "/login", body: data);
  //     var jsonResponse = json.decode(response.body);
  //     print(jsonResponse);
  //     if (jsonResponse['success'] == true) {
  //       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //       sharedPreferences.setString('userData', json.encode(jsonResponse));
  //       final extracteduserData = json.decode(sharedPreferences.getString('userData')) as Map<String, dynamic>;
  //       getItemMasterList();

  //      print(extracteduserData['system_access_id']);

  
        
  //     } else {
  //       print(jsonResponse['message']);
  //       throw HttpException(jsonResponse['message']);
  //     }
  //   } catch (error) {
  //     print(error);
  //     // print(responseCode);
  //     throw (error);
  //   }
  // }

    Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as String;
    // print(expiryDate);

    _token = extractedUserData;
    notifyListeners();
    return true;
  }
}