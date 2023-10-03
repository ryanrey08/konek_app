// Packages and Libraries
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart' as config;

// Config and Providers
// import '../../Config/Config.dart' as config;
// import '../../Config/HttpException.dart';

class Auth with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_token != '') {
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

    Future<void> register(Map<String, dynamic> userInfo) async {
    Map<String, dynamic> jsonResponse;

        Map<String, dynamic> jsonResponseRSBSA;

    try {
      final response = await http.post(
        (config.pre_url + config.auth_route + "/register") as Uri,
        body: userInfo,
      );

      // final validateRSBSA  = await http.post(
      //   config.pre_url + config.auth_validate_rsba,
      //   body: userInfo,
      // );

      // jsonResponseRSBSA = json.decode(validateRSBSA.body);
      // print(jsonResponseRSBSA['message']);

      jsonResponse = json.decode(response.body);
      print(jsonResponse);

      if (jsonResponse['success']) {
        final userData = json.encode(jsonResponse);
        print(userData);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', userData);
        notifyListeners();
      } else {
        
     if(jsonResponse['data']['rsbsa_no'][0] == 'The rsbsa no has already been taken.' && jsonResponse['type_error'] == 'contact')
        {
            var error = jsonResponse['data']['rsbsa_no']; 
              throw HttpException(error[0]);
        }
        else if(jsonResponse['type_error'] == 'contact')
        {
             var error = jsonResponse['data']['contact_number']; 
              throw HttpException(error[0]);
            // var errorRSBSA = jsonResponse['data']['rsbsa_bo']; 
            //  throw HttpException(errorRSBSA[0]);
              
        }
        else if (jsonResponse['type_error'] == 'rsbsa')
        {
            var error = jsonResponse['message']; 
              throw HttpException(error);
        }
        else
        {
          throw HttpException('Something went wrong. Please check your RSBSA and contact number again.');
        }
        
      }

      print(jsonResponse['message']);
    } catch (error) {
        throw (error);
    }

    notifyListeners();
  }
}