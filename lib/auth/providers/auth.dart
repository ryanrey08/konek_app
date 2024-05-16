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
import '../../config/HttpException.dart';

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

  Future<void> login(String contactNumber, String password) async {
    Map data = {'mobile_number': contactNumber, 'password': password};
    Map<String, dynamic> jsonResponse;
    var responseCode;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response =
          await http.post(Uri.parse("${config.pre_url}/login-via-mobile"), body: data);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success'] == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', json.encode(jsonResponse));
        if(jsonResponse['activePromo'] != null){
                sharedPreferences.setString(
          'swakPaymentRefNo', json.encode({"reference_number" : jsonResponse['activePromo']}));
        }else{
          sharedPreferences.setString(
          'swakPaymentRefNo', json.encode({"reference_number" : '00000'}));
        }
      } else {
        print("exp" + jsonResponse['message']);
        throw HttpException(jsonResponse['data']['mobile_number'][0].toString());
      }
    } catch (error) {
      print('error');
      print(error);
      // print(responseCode);
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map;
    // print(expiryDate);

    _token = extractedUserData['data']['token'];
    notifyListeners();
    return true;
  }

  Future<void> register(userInfo) async {
    print(userInfo);
    Map<String, dynamic> jsonResponse;


    try {
      final response = await http.post(
       Uri.parse("${config.pre_url}/register-v2"),
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
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', userData);
        notifyListeners();
      } else {
        if(jsonResponse['data']['email'] != null){
          throw HttpException(jsonResponse['data']['email'][0].toString());
        }else if(jsonResponse['data']['mobile_number'] != null){
          throw HttpException(jsonResponse['data']['mobile_number'][0].toString());
        }else if(jsonResponse['data']['first_name'] != null){
          throw HttpException(jsonResponse['data']['first_name'][0].toString());
        }else if(jsonResponse['data']['middle_name'] != null){
          throw HttpException(jsonResponse['data']['middle_name'][0].toString());
        }else if(jsonResponse['data']['last_name'] != null){
          throw HttpException(jsonResponse['data']['last_name'][0].toString());
        }else{
           throw HttpException('something went wrong');
        }
      }

      print(jsonResponse['message']);
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

    Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.remove('swakPaymentRefNo');
  }
}
