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

  Future<void> login(String contactNumber, String password, String deviceId) async {
    Map data = {'mobile_number': contactNumber, 'password': password, 'mac_address': deviceId};
    Map<String, dynamic> jsonResponse;
    var responseCode;
    // print(deviceId);
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response =
          await http.post(Uri.parse("${config.pre_url}/login"), body: data);
      var jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      if (jsonResponse['success'] == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', json.encode(jsonResponse));
        if (jsonResponse['data']['subcription'] != null) {
          sharedPreferences.setString('swakPaymentRefNo',
              json.encode({"reference_number": jsonResponse['data']['subcription']['ref_no']}));
        } else {
          sharedPreferences.setString(
              'swakPaymentRefNo', json.encode({"reference_number": '00000'}));
        }
      } else {
        // print("exp" + jsonResponse['message']);
        if (jsonResponse['message'] == 'Unauthorised.') {
          if(jsonResponse['data']['error'] == 'Device record mismatched'){
            throw HttpException('Device record mismatched');
          }else{
            throw HttpException('Invalid mobile number or password');
          }
        }
         else {
          throw HttpException('something went wrong');
        }
        // throw HttpException(jsonResponse['data']['mobile_number'][0].toString());
      }
    } catch (error) {
      // print('error');
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
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map;
    // print(expiryDate);

    _token = extractedUserData['data']['token'];
    notifyListeners();
    return true;
  }

  Future<void> register(userInfo) async {
    // print(userInfo);
    Map<String, dynamic> jsonResponse;

    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/register"),
        body: userInfo,
      );

      jsonResponse = json.decode(response.body);
      print(jsonResponse);

      if (jsonResponse['success']) {
        final userData = json.encode(jsonResponse);
        // print(userData);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', userData);
        notifyListeners();
      } else {
        if (jsonResponse['data']['email'] != null) {
          throw HttpException(jsonResponse['data']['email'][0].toString());
        } else if (jsonResponse['data']['mobile_number'] != null) {
          throw HttpException(
              jsonResponse['data']['mobile_number'][0].toString());
        } else if (jsonResponse['data']['first_name'] != null) {
          throw HttpException(jsonResponse['data']['first_name'][0].toString());
        } else if (jsonResponse['data']['middle_name'] != null) {
          throw HttpException(
              jsonResponse['data']['middle_name'][0].toString());
        } else if (jsonResponse['data']['last_name'] != null) {
          throw HttpException(jsonResponse['data']['last_name'][0].toString());
        } else {
          throw HttpException('something went wrong');
        }
      }

      // print(jsonResponse['message']);
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<bool> logout() async {
       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
        var jsonResponse;
    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/logout/" + token),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}
      );
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success']) {
        jsonResponse = json.decode(response.body);
          // sharedPreferences.remove('userData');
          // sharedPreferences.remove('swakPaymentRefNo');
          sharedPreferences.clear();
        return true;
      } else {
        jsonResponse = json.decode(response.body);
        return false;
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

    Future<Map<String, dynamic>> checkAccount() async {
       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
        var jsonResponse;
    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/check-if-active"),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}
      );
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success']) {
          // sharedPreferences.remove('userData');
          // sharedPreferences.remove('swakPaymentRefNo');
        return jsonResponse;
      } else {
        return jsonResponse;
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

    Future<Map<String, dynamic>> sendOTP(String number) async {
    int id = 0;
    var jsonResponse;
    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/send-otp"),
        body: {'mobile_number': number},
      );
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success']) {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

    Future<Map<String, dynamic>> checkUserCreds(String number, String email) async {
    int id = 0;
    var jsonResponse;
    print(number);
    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/check-creds"),
        body: {'mobile_number': number, 'email': email},
      );
      jsonResponse = json.decode(response.body);
      print(response.body);
      if (jsonResponse['success']) {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> checkUserExists(String number, String deviceId) async {
    int id = 0;
    var jsonResponse;
    print(number);
    try {
      final response = await http.post(
        Uri.parse("${config.pre_url}/check-number"),
        body: {'mobile_number': number, 'mac_address': deviceId},
      );
      jsonResponse = json.decode(response.body);
      print(response.body);
      if (jsonResponse['success']) {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        jsonResponse = json.decode(response.body);
        return jsonResponse;
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> changePassword(Map<String, dynamic> userData) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var userInfo = json.decode(sharedPreferences.getString('userData')!)
    //     as Map<String, dynamic>;
    // var token = userInfo['data']['token'];
    print(userData);

    Map<String, dynamic> jsonResponse;
    try {
      var response = await http.post(
          Uri.parse("${config.pre_url}/reset-password"),
          body: userData);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success'] == true) {
        return jsonResponse['success'];
      } else {
        if (jsonResponse['data']['new_password'] != null) {
          throw HttpException(
              jsonResponse['data']['new_password'][0].toString());
        } else if (jsonResponse['data']['confirm_password'] != null) {
          throw HttpException(
              jsonResponse['data']['confirm_password'][0].toString());
        } else {
          throw HttpException('something went wrong');
        }
        // throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }
}
