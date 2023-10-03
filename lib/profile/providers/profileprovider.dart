
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
  String _token;

  ProfileProvider(this._token);

  Future<bool> updateProfiling(
      // String status, Map<String, dynamic> basicInfo, Map<String, dynamic> businessDetails, Map<String, dynamic> req, int id) async {
   String ftoken,Map<String, dynamic> farmerInfo) async {
 
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(sharedPreferences.getString('userData')!) as Map<String, dynamic>;
    var token = userInfo['token'];

    //  Map data ={'token': ftoken,'data': json.encode(farmerInfo) as Map<String, dynamic>};
    // Map data = farmerInfo;
    print(token);
    Map<String, dynamic> jsonResponse;
    print(farmerInfo);
    try {

      
      //  Route::post('/farmer/update-profile', 'FarmerController@updateProfile
      var response = await http.post((config.pre_url + config.auth_update_profile) as Uri,
          body: farmerInfo, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
// Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('userData', json.encode(farmerInfo));
        return jsonResponse['success'];
      } else {
        throw HttpException(jsonResponse['message']);
      }
       
    } catch (error) {
      print(error);
      print('error here update profile');
      // print(responseCode);
      throw (error);
    }
  }


}