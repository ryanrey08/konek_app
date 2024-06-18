import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Config and Providers
import '../../../Config/Config.dart' as config;
// import '../../Config/HttpException.

class ProfileProvider with ChangeNotifier {
  final String _token;

  ProfileProvider(this._token);

  Future<bool> updateProfile(
      // String status, Map<String, dynamic> basicInfo, Map<String, dynamic> businessDetails, Map<String, dynamic> req, int id) async {
      Map<String, dynamic> userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];

    //  Map data ={'token': ftoken,'data': json.encode(farmerInfo) as Map<String, dynamic>};
    // Map data = farmerInfo;
    // print(token);
    Map<String, dynamic> jsonResponse;
    try {
      //  Route::post('/farmer/update-profile', 'FarmerController@updateProfile
      var response = await http.post(
          Uri.parse("${config.auth_update_profile}update-profile"),
          body: userData,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
// Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        // SharedPreferences sharedPreferences =
        //     await SharedPreferences.getInstance();
        // sharedPreferences.setString('userData', json.encode(userInfo));
        return jsonResponse['success'];
      } else {
        throw HttpException(jsonResponse['message']);
      }
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }

      Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;

    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(
          Uri.parse("${config.auth_update_profile}my-profile"),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse;
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProvince() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(
          Uri.parse("${config.my_address}get-province"),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse;
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCity(code) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(
          Uri.parse("${config.my_address}get-city/" + code),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse = json.decode(response.body);
      notifyListeners();
      return jsonResponse;
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }

    Future<Map<String, dynamic>> getBarangay(provCode, munCode) async {
      print(provCode + " " + munCode);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!)
        as Map<String, dynamic>;
    var phoneNo;
    if (userInfo['data']['user'] != null) {
      phoneNo = userInfo['data']['user']['mobile_no'];
    } else {
      phoneNo = userInfo['data']['mobile_no'];
    }
    var token = userInfo['data']['token'];
    var responseCode;
    try {
      var response = await http.get(
          Uri.parse("${config.my_address}get-brgy/" + provCode + "/" + munCode),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      notifyListeners();
      return jsonResponse;
    } catch (error) {
      // print(responseCode);
      rethrow;
    }
  }
}
