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
final String pre_url = "http://157.230.37.42/api/v1/auth";
final String pre_url_voucher = "http://157.230.37.42/api/v1/voucher";
final String pre_url_subscription = "http://157.230.37.42/api/v1/subscriptions";
final String pre_url_ads = "http://157.230.37.42/api/v1/quick-links-and-ads";
final String img_url = "http://192.168.42.88:8000/storage/";
final String file_storage = "http://157.230.37.42/storage/";

//staging
// final String pre_url = "http://128.199.240.216";
// final String img_url = "http://128.199.240.216/storage/";

//test server
// final String pre_url = "http://159.223.72.52";
// final String img_url = "http://159.223.72.52/storage/";


//final String pre_url = "http://192.168.100.197:8080";
//final String img_url = "http://192.168.100.197:8080/storage/";

// /public/storage/ecabs/images/updates/'.$value

final String auth_route = "/api/eagro/auth";

  // Route::post('/farmer/update-profile', 'FarmerController@updateProfile');
final String auth_update_profile = "/api/eagro/farmer/update-profile-mobile";
final String auth_update_supplier_profile = "/api/eagro/supplier/update-profile-supplier-mobile";
final String auth_validate_rsba = "/api/eagro/farmer/validate-rsbsa";
final String auth_save_cash_loan= "/api/eagro/loan-application/save-loan-application";
final String auth_save_ampalaya_loan= "/api/eagro/loan-application/ampalaya-loan-application";
final String auth_save_talong_loan= "/api/eagro/loan-application/talong-loan-application";
final String auth_save_okra_loan= "/api/eagro/loan-application/okra-loan-application";
final String auth_save_sitaw_loan= "/api/eagro/loan-application/sitaw-loan-application";
final String auth_save_sili_loan= "/api/eagro/loan-application/sili-loan-application";
final String auth_save_kalabasa_loan= "/api/eagro/loan-application/kalabasa-loan-application";
final String auth_save_kamatis_loan= "/api/eagro/loan-application/kamatis-loan-application";
final String auth_save_pakwan_loan= "/api/eagro/loan-application/pakwan-loan-application";
final String auth_farmer_list = "/api/eagro/dlo/farmer-list";
final String auth_supplier_list = "/api/eagro/dlo/supplier-list";

final String auth_farmer_approved = "/api/eagro/dlo/approve-farmer/";
final String auth_farmer_disapproved = "/api/eagro/dlo/disapproved-farmer/";

final String auth_supplier_approved = "/api/eagro/dlo/approve-supplier/";
final String auth_supplier_disapproved = "/api/eagro/dlo/disapproved-supplier/";

final String auth_farmer_loan_list = "/api/eagro/dlo/loan-list";
final String auth_farmer_loan_approved = "/api/eagro/dlo/approved-loan/";
final String auth_farmer_loan_disapproved = "/api/eagro/dlo/disapproved-loan/";
final String auth_farmer_loan_application_data = "/api/eagro/farmer/get-loan-application-data";
final String auth_get_crop_type_by_id = "/api/eagro/farmer/get-croptype-by-id";

final String auth_my_loans = "/api/eagro/farmer/my-loans/";




final String item_master_list = "/api/eagro/masterlist/get-masterlist";

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
