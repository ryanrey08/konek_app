import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

//dev-e-agro
// final String pre_url = "http://159.223.37.192";
// final String img_url = "http://159.223.37.192/storage/";

//my local
//final String pre_url = "http://192.168.42.88:8000";
const String pre_url = "http://165.22.253.81:1904/api/v1/auth";
const String pre_url_voucher = "http://165.22.253.81:1904/api/v1/voucher";
const String pre_url_subscription = "http://165.22.253.81:1904/api/v1/subscriptions";
const String pre_url_ads = "http://165.22.253.81:1904/api/v1/quick-links-and-ads";
const String img_url = "http://192.168.42.88:8000/storage/";
const String file_storage = "http://165.22.253.81:1904/storage/";
const String hit_pay = "http://165.22.253.81:1904/api/v1/hitpay/";
const String my_address = "http://165.22.253.81:1904/api/v1/utilities/";
const String auth_update_profile = "http://165.22.253.81:1904/api/v1/account/";

//staging
// final String pre_url = "http://128.199.240.216";
// final String img_url = "http://128.199.240.216/storage/";

//test server
// final String pre_url = "http://159.223.72.52";
// final String img_url = "http://159.223.72.52/storage/";


//final String pre_url = "http://192.168.100.197:8080";
//final String img_url = "http://192.168.100.197:8080/storage/";

// /public/storage/ecabs/images/updates/'.$value




const String item_master_list = "/api/eagro/masterlist/get-masterlist";

String throwErrorAuth(String error) {
  var errorMessage = 'Something went wrong';
  if (error.toString().contains('SocketException: OS Error: No route to host')) {
    errorMessage = 'Server error, under maintenance';
  } else if (error.toString().contains('SocketException: Connection failed')) {
    errorMessage = 'Network error, Please check your connection';
  }
  return errorMessage;
}

// late Preference<String> globalVoucherData;
