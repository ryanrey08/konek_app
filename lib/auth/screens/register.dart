import 'package:konek_app/auth/providers/auth.dart';
import 'package:konek_app/auth/screens/login.dart';
//import 'package:konek_app/Screen/RegisterSuccesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:loader_overlay/loader_overlay.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../../content/dashboard.dart';

import '/config/config.dart' as config;
import '../../features/widgets.dart';

// Models
import '/auth/models/user.dart';
// Config and Providers
import '/auth/providers/auth.dart';
import '/config/HttpException.dart';
import 'Splashscreen.dart';

const String CAPTCHA_SITE_KEY = "6LcSiSQdAAAAAOyoKM6G5CeLAPE-P5ApqwNMUQaV";

class AccountRegister extends StatefulWidget {
  static const routeName = '/register';
  @override
  _AccountRegisterState createState() => _AccountRegisterState();
}

class _AccountRegisterState extends State<AccountRegister> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final txtrsbsanumber = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtMiddleName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtBirthday = TextEditingController();
  final txtContactNumber = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final txtOTP = TextEditingController();
  final txtCompanyName = TextEditingController();

  final fNameFocus = FocusNode();
  final mNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final companyName = FocusNode();
  final uNameFocus = FocusNode();
  final contactFocus = FocusNode();
  final passwordFocus = FocusNode();
  final afiFocus = FocusNode();
  final bdayFocus = FocusNode();
  final civilFocus = FocusNode();
  final genderFocus = FocusNode();
  final homeAFocus = FocusNode();
  final provinceFocus = FocusNode();
  final cityFocus = FocusNode();
  final brgyFocus = FocusNode();
  final zipFocus = FocusNode();
  final spiritualBdate = FocusNode();

  var _selectedUserType;
  var _userType = ['FARMER', 'SUPPLIER'];

  List<dynamic> _region = [];
  List<dynamic> _province = [];
  List<dynamic> _municipality = [];
  List<dynamic> _barangay = [];

  List<dynamic> _regionsId = [];
  List<dynamic> _tempMunicipalityKeys = [];
  List<dynamic> _tempMunicipality = [];
  var _tempRegion = {};

  var _jsonResult;
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;

  TextEditingController _numberController = TextEditingController();
  double appBarHeight = AppBar().preferredSize.height;

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "##########", filter: {"#": RegExp(r'[0-9]')});

  var userStatus = ['CBBC USER', 'ADMIN'];

  var userInfo = User(
    rsbsa_no: "",
    last_name: "",
    first_name: "",
    middleName: "",
    birthdate: "",
    contact_number: "",
    password: "",
    email: "",
    confirm_password: "",
    status: '',
  );

  bool isChecked = false;

  final _form = GlobalKey<FormState>();
  bool isNotARobot = false;

  void initState() {
    super.initState();

    _selectedUserType = 'FARMER';
  }

  Future<void> register() async {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      return;
    }
    _form.currentState!.save();
    // await Provider.of<Auth>(context, listen: false).register(userInfo);
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff404747),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  Future<void> proceed() async {
    var errorMessage;
    bool isValidUser = false;
    final isValid = _form.currentState!.validate();

    var number;
//     var user = {
//       'rsbsa_no': "",
//       'last_name': "",
//       'first_name': "",
// //       'middle_name': "",
//       'birthdate': "",
//       'contact_number': "",
// //       'password': "",
// //       'password_confirmation': "",
//     };
    try {
      _form.currentState!.save();

      var user = {
        'rsbsa_no': txtrsbsanumber.text,
        'last_name': txtLastName.text,
        'first_name': txtFirstName.text,
//                     'middle_name': txtMiddleName.text,
        'birthdate': txtBirthday.text,
        'contact_number': txtContactNumber.text,
        'user_type': _selectedUserType.toString(),
//                     'password': txtPassword.text,
      };

      print(user);
      await Provider.of<Auth>(context, listen: false).register(user);
      final sharedPreferences = await SharedPreferences.getInstance();

      if (sharedPreferences.containsKey('userData')) {
        Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
      } else {}
    } on HttpException catch (error) {
      print('here');
      showError(error.toString());
    } catch (error) {
      showError('something went wrong');
    }

    // print(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    // final data = MediaQuery.of(context);

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool _hidePassword = true;
    bool _hideConfirmPassword = true;

    final format = DateFormat("MM/dd/yyyy");

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 55, 57, 175),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/eaggro-bg.jpg'),
          //     fit: BoxFit.cover,
          //     // colorFilter: ColorFilter.mode(
          //     //   Colors.black.withOpacity(0.2),
          //     //   BlendMode.dstATop,
          //     // ),
          //   ),
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     stops: [0.1, 0.8],
          //     colors: [Colors.green.shade300],
          //   ),
          // ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   width: useMobileLayout ? 280 : 400,
                  //   height: useMobileLayout ? 280 : 400,
                  //   // width: 250,
                  //   // height: 250,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage('assets/images/eaggro-1.png'),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    //  height: MediaQuery.of(context).size.height / 1.65,
                    width: useMobileLayout
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width - 200,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(30),
                    //         topRight: Radius.circular(30),
                    //         bottomLeft: Radius.circular(30),
                    //         bottomRight: Radius.circular(30)),
                    //     color: Colors.white.withOpacity(0.8)),
                    padding: EdgeInsets.symmetric(
                        horizontal: useMobileLayout ? 15 : 30),
                    margin: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: useMobileLayout ? 100 : 220,
                            height: useMobileLayout ? 100 : 220,
                            alignment: Alignment.topRight,
                            // width: 250,
                            // height: 250,

                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/novulutions.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "CREATE YOUR ACCOUNT",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: useMobileLayout ? 15 : 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          customTextField('First Name', txtFirstName,
                              useMobileLayout, 'Please enter your First Name'),
                          customTextField('Middle Name', txtMiddleName,
                              useMobileLayout, 'Please enter your Middle Name'),
//                           customTextField('Middle Name', txtMiddleName,
//                               useMobileLayout, 'Please enter your Middle Name'),
                          customTextField('Last Name', txtLastName,
                              useMobileLayout, 'Please enter your Last Name'),
                          // SizedBox(
                          //   height: 15,
                          // ),
                          customTextField('Email', txtEmail, useMobileLayout,
                              'Please enter your Email'),
                          customTextField(
                              'Mobile Number (09XXXXXXXXX)',
                              txtContactNumber,
                              useMobileLayout,
                              'Please enter your contact number'),
                          mypassword('Password', Icons.password, txtPassword,
                              useMobileLayout),
                          confirmpassword("Confirm Password", Icons.password,
                              txtConfirmPassword, useMobileLayout),
                          Container(
                              child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                //fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Expanded(
                                  child: Text(
                                "I agree the Terms and Conditions and Privacy Policy",
                                style: GoogleFonts.poppins(color: Colors.white),
                              ))
                            ],
                          )),

                          SizedBox(
                            height: 10,
                          ),
//                           mypassword(
//                               "", Icons.lock, txtPassword, useMobileLayout),
//                           confirmpassword("", Icons.lock, txtConfirmPassword,
//                               useMobileLayout),
                          // Proceed(proceed),
                          signUpButton(useMobileLayout),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account?',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize:
                                        useMobileLayout ? 16 : 18, // tablet
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed(Login.routeName),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: useMobileLayout ? 16 : 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder _textFormBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff088181),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Container customTextField(String hintTextP, TextEditingController control,
      bool useMobileLayout, String validator) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              obscureText: hintTextP != "" ? false : _hidePassword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: useMobileLayout ? 16 : 18,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: true,
                hintText: hintTextP,
                hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: useMobileLayout ? 14 : 16,
                    color: Colors.grey,
                  ),
                ),
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent[700],
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: hintTextP == ""
                    ? IconButton(
                        icon: _hidePassword
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibility,
                      )
                    : null,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return validator;
                }
                return null;
              },
              onChanged: (value) {
                // if (hintTextP.contains("RSBSA Number")) {
                //   validateRSBA(value, useMobileLayout);
                // }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container mypassword(String hintTextP, IconData preIcon,
      TextEditingController control, bool useMobileLayout) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: control,
              obscureText: hintTextP != "" ? false : _hidePassword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: true,
                hintText: "Password",
                hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent[700],
                  ),
                ),
                //         labelText: widget.controller.text != "" ? widget.title : null,
                // labelStyle: widget.controller.text != ""
                //     ? GoogleFonts.poppins(
                //         textStyle: TextStyle(
                //           fontSize: 16,
                //           color: Colors.grey,
                //         ),
                //       )
                //     : null,

                fillColor: Colors.grey[200],
                filled: true,
                suffixIcon: hintTextP == ""
                    ? IconButton(
                        icon: _hidePassword
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibility,
                      )
                    : null,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Container confirmpassword(String hintTextP, IconData preIcon,
      TextEditingController control, bool useMobileLayout) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              obscureText: hintTextP != "" ? false : _hidePassword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: true,
                hintText: "Confirm Password",
                hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent[700],
                  ),
                ),
                //         labelText: widget.controller.text != "" ? widget.title : null,
                // labelStyle: widget.controller.text != ""
                //     ? GoogleFonts.poppins(
                //         textStyle: TextStyle(
                //           fontSize: 16,
                //           color: Colors.grey,
                //         ),
                //       )
                //     : null,

                fillColor: Colors.grey[200],
                filled: true,
                suffixIcon: hintTextP == ""
                    ? IconButton(
                        icon: _hidePassword
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibility,
                      )
                    : null,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void toggleVisibilityConfirm() {
    setState(() {
      _hideConfirmPassword = !_hideConfirmPassword;
    });
  }

  void toggleVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  // Controls
  void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff404747),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  Container signUpButton(bool useMobileLayout) {
    return Container(
      // height: useMobileLayout ? 50 : 70,
      height: 60,

      child: SizedBox.expand(
        child: TapDebouncer(
          onTap: () async {
            // Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
            if (!_formKey.currentState!.validate()) {
              return;
            } else {
              setState(() {
                _isLoading = true;
              });

              Alert(
                  context: context,
                  title: "",
                  content: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: useMobileLayout ? 200 : 300,
                          height: useMobileLayout ? 200 : 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/eaggro-1.png'),
                            ),
                          ),
                        ),
                        Text(
                          'The OTP password was sent to the following recipient:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: txtOTP,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                    enabled: true,
                                    hintText: 'Enter OTP code',
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    errorStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.redAccent[700],
                                      ),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter the OTP code';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  buttons: [
                    DialogButton(
                      color: Colors.green,
                      onPressed: () async {
                        // Navigator.of(context)
                        //     .pushReplacementNamed(Dashboard.routeName);

                        try {
                          _formKey.currentState!.save();

                          var user = {
                            'rsbsa_no': _selectedUserType == 'FARMER'
                                ? txtrsbsanumber.text
                                : '',
                            'last_name': txtLastName.text,
                            'first_name': txtFirstName.text,
                            'birthdate': txtBirthday.text,
                            'farmer_contact_number': txtContactNumber.text,
                            'g-recaptcha-response': true,
                            'user_type': _selectedUserType.toString(),
                            'supplier_type': "1",
                            'company_name': _selectedUserType == 'SUPPLIER'
                                ? txtCompanyName.text
                                : ''
                          };

                          print(user);
                          await Provider.of<Auth>(context, listen: false)
                              .register(user);
                          final sharedPreferences =
                              await SharedPreferences.getInstance();

                          if (sharedPreferences.containsKey('userData')) {
                            //          Navigator.of(context)
                            // .pushReplacementNamed(RegisterSuccessScreen.routeName);

                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         RegisterSuccessScreen(),
                            //   ),
                            //   (route) => false,
                            // );
                            //   Navigator.pushAndRemoveUntil(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) =>
                            //         MySplashScreen(Dashboard())),
                            // ModalRoute.withName("/dashboard"));
                          } else {}
                        } on HttpException catch (error) {
                          print('here');
                          txtOTP.clear();
                          Navigator.of(context).pop();
                          showError(error.toString());
                        } catch (error) {
                          showError('Something went wrong.');
                        }
                      },
                      child: Text(
                        "Verify",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ]).show();
            }
          }, // your tap handler moved here
          builder: (context, onTap) {
            return ElevatedButton(
              child: Text(
                "SIGN UP",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: useMobileLayout ? 16 : 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 0), // background
                onPrimary: Colors.white, // foreground
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),

              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(50.0),
              // ),
              onPressed: onTap,
              // color: Colors.green,
              // textColor: Colors.black,
              // splashColor: Colors.yellowAccent[800],
            );
          },
        ),
      ),
    );
  }
}
