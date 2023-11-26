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

class Voucher with ChangeNotifier {
  String? _token;

  Voucher(this._token);
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

  Future<Map<String, dynamic>> registerVoucherCode(String voucher_code) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    Map data = {'voucher_code': voucher_code};
    Map<String, dynamic> jsonResponse;
    var responseCode;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response = await http.post(
          Uri.parse(config.pre_url_voucher + "/apply-voucher"),
          body: data,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['success'] == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'voucherData', json.encode(jsonResponse['data']));
        final preferences = await StreamingSharedPreferences.instance;
        preferences.setString('voucherData', json.encode(jsonResponse['data']));

        return jsonResponse['data'];

      } else {
        print(jsonResponse['message']);
        throw HttpException(jsonResponse['data'].toString());
        // var data = {
        //   "voucher_code": "GNXPMX",
        //   "duration": 1,
        //   "description": "1 DAY UNLI DATA-ABC",
        //   "amount": 50,
        //   "claimed_date": "2023-11-15 07:45:58",
        //   "expire_date": "2023-11-26 15:28:00",
        //   "status": "Registred"
        // };
        // SharedPreferences sharedPreferences =
        //     await SharedPreferences.getInstance();
        // sharedPreferences.setString(
        //     'voucherData', json.encode(data));
        // final preferences = await StreamingSharedPreferences.instance;
        // preferences.setString('voucherData', json.encode(data));
        // return data;
      }
    } catch (error) {
      print(error);
      // print(responseCode);
      throw (error);
    }
  }

  Future<List<dynamic>> getMyVoucher() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(
          Uri.parse(config.pre_url_voucher + "/get-my-vouchers"),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      //print(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse["data"];
    } catch (error) {
      print(error);
      // print(responseCode);
      throw (error);
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
    print(userInfo);
    Map<String, dynamic> jsonResponse;

    try {
      final response = await http.post(
        Uri.parse(config.pre_url + "/register"),
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
        throw HttpException('Something went wrong.');
      }

      print(jsonResponse['message']);
    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}
