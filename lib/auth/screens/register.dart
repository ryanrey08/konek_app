import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:konek_app/auth/providers/auth.dart';
import 'package:konek_app/auth/screens/login.dart';
//import 'package:konek_app/Screen/RegisterSuccesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/auth/screens/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:grecaptcha/grecaptcha.dart';
import 'package:grecaptcha/grecaptcha_platform_interface.dart';
import 'package:hcaptcha/hcaptcha.dart';
import 'package:geolocator/geolocator.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter/services.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:flutter_device_id/flutter_device_id.dart';
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

const String CAPTCHA_SITE_KEY = "6LeVSg4qAAAAAHK97rol9rhvDkGwQdSdpJDqJrQm";

class AccountRegister extends StatefulWidget {
  static const routeName = '/register';

  const AccountRegister({super.key});
  @override
  _AccountRegisterState createState() => _AccountRegisterState();
}

class _AccountRegisterState extends State<AccountRegister> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final txtFirstName = TextEditingController();
  final txtMiddleName = TextEditingController();
  final txtAge = TextEditingController();
  final txtLastName = TextEditingController();
  final txtBirthday = TextEditingController();
  final txtEmail = TextEditingController();
  final txtBrgyAddress = TextEditingController();
  final txtContactNumber = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  TextEditingController _otpcode = TextEditingController();

  final fNameFocus = FocusNode();
  final mNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();

  var _selectedUserType;

  final List<dynamic> _region = [];
  final List<dynamic> _province = [];
  final List<dynamic> _municipality = [];
  final List<dynamic> _barangay = [];

  final List<dynamic> _regionsId = [];
  final List<dynamic> _tempMunicipalityKeys = [];
  final List<dynamic> _tempMunicipality = [];
  final _tempRegion = {};

  var _jsonResult;
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;

  final TextEditingController _numberController = TextEditingController();
  double appBarHeight = AppBar().preferredSize.height;

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "##########", filter: {"#": RegExp(r'[0-9]')});

  var userInfo = User(
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

  // var data;

  bool isCheckedLoad = false;
  bool isChecked = false;

  final _form = GlobalKey<FormState>();
  bool isNotARobot = false;

  final String _platformVersion = 'Unknown';
  final String _serialNumber = "--";


  var _deviceId;
  final _mobileDeviceIdentifierPlugin = MobileDeviceIdentifier();

  var data;
  bool isOtpValid = false;
  var otpTimer;
  bool isOTPExpire = false;
  bool isResend = false;

  @override
  void initState() {
    super.initState();
    txtBirthday.text = 'January 01, 1990';
    // initDeviceId();
    getMobileID();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    String? subsData = ModalRoute.of(context)?.settings.arguments as String?;

    if (subsData != null) {
      setState(() {
        txtContactNumber.text = subsData;
      });
    }
  }

  void getMobileID() async {
    final _flutterDeviceIdPlugin = FlutterDeviceId();

    String? deviceId = await _flutterDeviceIdPlugin.getDeviceId() ?? '';

    setState(() {
      _deviceId = deviceId;
    });
  }

  void showTermsAndConditions() {
    showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => Center(
              child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 150,
                  child: TermsAndConditions()),
            ));
  }

  Future<void> initDeviceId() async {
    String deviceId;
    try {
      deviceId = await _mobileDeviceIdentifierPlugin.getDeviceId() ??
          'Unknown platform version';
    } on PlatformException {
      deviceId = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;

      // print(_deviceId);
    });
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
      backgroundColor: const Color(0xff404747),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  final String _token = 'Click the below button to generate token';
  bool badgeVisible = true;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _openReCaptcha() async {
    Grecaptcha()
        .verifyWithRecaptcha('6LeVSg4qAAAAAHK97rol9rhvDkGwQdSdpJDqJrQm')
        .then((result) {
      // print(result);
      if (result != '') {
        setState(() {
          isNotARobot = true;
        });
      }
      // You can send the result token, along with some form fields, to your
      // server, which can verify the token using an endpoint proved by the
      // reCAPTCHA API for servers, see https://developers.google.com/recaptcha/docs/verify
    }, onError: (e, s) {
      // An error doesn't have to mean that the user is not a human. Errors
      // can also occur when the sitekey is invalid or does not match your
      // application, when the device is not supported or when a network
      // error occurs.
      // You should inform the user of errors, explaining why they can't
      // proceed. As the plugin is not available for iOS, you might consider
      // skipping the reCAPTCHA step when FGrecaptcha.isAvailable is false.
      // print("Could not verify:\n $e at $s");
    });
  }

  Future<void> checkUserCreds(BuildContext context1) async {
    var data;
    try {
      data = await Provider.of<Auth>(context, listen: false)
          .checkUserCreds(txtContactNumber.text, txtEmail.text);
      if (data['success']) {
        sendOTP(context1);
      } else {
        if (data['data'].containsKey('mobile_number')) {
          _showErrorMessage(data['data']['mobile_number'][0]);
        } else {
          _showErrorMessage(data['data']['email'][0]);
        }
        setState(() {
          _isLoading = false;
        });
      }
    } on HttpException catch (error) {
      var message = "Error";
      if (error.toString().contains('User not found')) {
        message = 'User not found';
      }
      _showErrorMessage(message);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var message = "Something went wrong";
      _showErrorMessage(message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> sendOTP(BuildContext context1) async {
    try {
      data = await Provider.of<Auth>(context, listen: false)
          .sendOTP(txtContactNumber.text);
      // setState(() {
      //   data = dataOTP;
      // });
      if (data['success']) {
        setState(() {
          isOTPExpire = true;
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Alert(
            context: context,
            onWillPopActive: true,
            title:
                "Verify Your Mobile Number \n Please enter the One-Time Password (OTP) sent to your mobile number " +
                    txtContactNumber.text +
                    ". This OTP is valid for 10 minutes.",
            style: AlertStyle(
                titleStyle:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            content: StatefulBuilder(
              builder: (BuildContext context1, StateSetter setState) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        // margin: EdgeInsets.only(bottom: 5),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                  controller: _otpcode,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    helperText: "Enter OTP Code",
                                    helperStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 10,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: '- - - - - -',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 50),
                                    errorText:
                                        isOtpValid ? 'Invalid Code' : null,
                                    errorStyle: TextStyle(fontSize: 12),
                                  ),
                                  autocorrect: false,
                                  // inputFormatters: [maskTextInputFormatter],
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    print(value.length);
                                    if (value.length >= 6) {
                                      setState(() {
                                        value = value.substring(0, 6);
                                        _otpcode.text = value;
                                      });
                                    }
                                  }),
                            ),
                            Text(
                              "Didn't receive the OTP?",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16, // tablet
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            !isResend
                                ? (isOTPExpire
                                    ? TimerCountdown(
                                        format:
                                            CountDownTimerFormat.minutesSeconds,
                                        spacerWidth: 5,
                                        timeTextStyle: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                        enableDescriptions: false,
                                        colonsTextStyle: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                        endTime: DateTime.now().add(
                                          Duration(
                                            // days: 0,
                                            // days: 5,
                                            // hours: 0,
                                            minutes: 10,
                                            seconds: 0,
                                          ),
                                        ),
                                        onEnd: () {
                                          setState(() {
                                            isOTPExpire = false;
                                          });

                                          return;
                                        },
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            isResend = true;
                                          });
                                          try {
                                            var dataOTP =
                                                await Provider.of<Auth>(context,
                                                        listen: false)
                                                    .sendOTP(
                                                        txtContactNumber.text);
                                            if (dataOTP['success']) {
                                              setState(() {
                                                data = dataOTP;
                                                isOTPExpire = true;
                                                isResend = false;
                                                _otpcode.text = '';
                                              });
                                            } else {
                                              setState(() {
                                                _otpcode.text = '';
                                                isResend = false;
                                              });
                                              AwesomeDialog(
                                                dismissOnBackKeyPress: false,
                                                dismissOnTouchOutside: false,
                                                onDismissCallback:
                                                    (BuildContext) {
                                                  // Navigator.pushReplacementNamed(context, Dashboard.routeName);
                                                },
                                                context: context,
                                                animType: AnimType.scale,
                                                dialogType: DialogType.error,
                                                title: "Error",
                                                desc: "Something went wrong",
                                                btnOkOnPress: () {
                                                  // Navigator.pushReplacementNamed(context, Dashboard.routeName);
                                                  // print(_selectedProvince);
                                                },
                                              ).show();
                                            }

                                            // setState(() {
                                            //   _isLoading = false;
                                            // });
                                          } on HttpException catch (error) {
                                            var message = "Error";
                                            if (error
                                                .toString()
                                                .contains('User not found')) {
                                              message = 'User not found';
                                            }
                                            _showErrorMessage(message);
                                          } catch (error) {
                                            var message =
                                                "Something went wrong";
                                            _showErrorMessage(message);
                                          }
                                        },
                                        child: Text(
                                          'Resend OTP',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.amberAccent),
                                          ),
                                        ),
                                      ))
                                : CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            buttons: [
              DialogButton(
                color: Color.fromARGB(255, 55, 57, 175),
                onPressed: () async {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(Dashboard.routeName);
                  // updateMyPassword();
                  print(_otpcode.text);
                  print(data['otp']);
                  setState(() {
                    isOTPExpire = false;
                  });
                  if (_otpcode.text == data['data']['otp']) {
                    print("here");
                    _determinePosition();
                  } else {
                    setState(() {
                      isOtpValid = true;
                      Fluttertoast.showToast(
                        msg: 'Invalid OTP Code',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff404747),
                        textColor: Colors.white,
                        fontSize: 13.0,
                      );
                    });
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ]).show();
      } else {
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          onDismissCallback: (BuildContext) {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Something went wrong",
          btnOkOnPress: () {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // print(_selectedProvince);
          },
        ).show();
      }

      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (error) {
      var message = "Error";
      if (error.toString().contains('User not found')) {
        message = 'User not found';
      }
      _showErrorMessage(message);
    } catch (error) {
      var message = "Something went wrong";
      _showErrorMessage(message);
    }
  }

  void _showErrorMessage(String message) {
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

  Future<void> resendOTP() async {
    try {
      var dataOTP = await Provider.of<Auth>(context, listen: false)
          .sendOTP(txtContactNumber.text);
      if (dataOTP['success']) {
        // setState(() {
        //   data = dataOTP;
        //   isOTPExpire = true;
        //   print(data);
        // });
      } else {
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          onDismissCallback: (BuildContext) {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: "Error",
          desc: "Something went wrong",
          btnOkOnPress: () {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // print(_selectedProvince);
          },
        ).show();
      }

      // setState(() {
      //   _isLoading = false;
      // });
    } on HttpException catch (error) {
      var message = "Error";
      if (error.toString().contains('User not found')) {
        message = 'User not found';
      }
      _showErrorMessage(message);
    } catch (error) {
      var message = "Something went wrong";
      _showErrorMessage(message);
    }
  }

  Future<void> _determinePosition() async {
    // bool serviceEnabled;
    // LocationPermission permission;

    // // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   showDialog<String>(
    //     context: context,
    //     builder: (BuildContext context) => AlertDialog(
    //       title: const Text('Cannot Acess Location'),
    //       content: const Text('Location permissions are denied'),
    //       actions: <Widget>[
    //         // TextButton(
    //         //   onPressed: () => Navigator.pop(context, 'Cancel'),
    //         //   child: const Text('Cancel'),
    //         // ),
    //         TextButton(
    //           onPressed: () => Navigator.pop(context, 'OK'),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //return await Geolocator.getCurrentPosition();
    String? errorMessage;
    try {
      // Position position = await Geolocator.getCurrentPosition();
      // print(position.latitude.toString());
      // print(position.longitude.toString());

      Map<String, dynamic> user = {
        'first_name': txtFirstName.text,
        'middle_name': txtMiddleName.text,
        'age': txtAge.text,
        'last_name': txtLastName.text,
        'date_of_birth': txtBirthday.text.toString(),
        'email': txtEmail.text,
        'address': txtBrgyAddress.text,
        'mobile_number': txtContactNumber.text,
        'password': txtPassword.text,
        'confirm_password': txtConfirmPassword.text,
        // 'location': json.encode({
        //   'longitude': position.longitude.toString(),
        //   'latitude': position.latitude.toString()
        // }),
        'location': 'n/a',
        'mac_address': _deviceId
      };

      await Provider.of<Auth>(context, listen: false).register(user);
      final sharedPreferences = await SharedPreferences.getInstance();

      if (sharedPreferences.containsKey('userData')) {
        Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
        // Navigator.of(context).pushReplacementNamed(MainDashboard.routeName);
        // Navigator.of(context).pushNamedAndRemoveUntil(Dashboard.routeName, (Route<dynamic> route) => false);
      }
    } on HttpException catch (error) {
      errorMessage = 'Authentication failed';
      if (error.toString().contains('something went wrong')) {
        errorMessage = 'something went wrong';
      } else {
        errorMessage = error.toString();
      }
      setState(() {
        _isLoading = false;
      });
      _showError(errorMessage);
    } catch (error) {
      // print(error);
      errorMessage = config.throwErrorAuth(error.toString());
      setState(() {
        _isLoading = false;
      });
      _showError(errorMessage);
    }
  }

  // getMyMac(){
  //   _getMacAddress();
  // }

  // Future<void>  _getMacAddress() async {
  //   String mac = await GetMac.macAddress;
  //   print("here" + mac);

  //      setState(() {
  //     _deviceMAC = mac;
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    txtFirstName.dispose();
    txtLastName.dispose();
    txtMiddleName.dispose();
    txtContactNumber.dispose();
    txtEmail.dispose();
    txtBrgyAddress.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    // final data = MediaQuery.of(context);

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool hidePassword = true;
    bool hideConfirmPassword = true;

    final format = DateFormat("MM/dd/yyyy");
    HCaptcha.init(siteKey: '6LeVSg4qAAAAAHK97rol9rhvDkGwQdSdpJDqJrQm');

    //getToken();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 55, 57, 175),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      margin: const EdgeInsets.only(
                          left: 10, bottom: 10, right: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: useMobileLayout ? 130 : 220,
                              height: useMobileLayout ? 80 : 220,
                              alignment: Alignment.topRight,
                              // width: 250,
                              // height: 250,

                              decoration: const BoxDecoration(
                                // color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                  scale: 6,
                                  image: AssetImage(
                                      'assets/images/move_mandaue_swak.png'),
                                ),
                              ),
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            customTextField(
                                TextInputType.text,
                                'First Name',
                                txtFirstName,
                                useMobileLayout,
                                'Please enter your First Name', (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your First Name';
                              }

                              if (!RegExp(r"^[\p{L} ,.'-]*$",
                                      caseSensitive: false,
                                      unicode: true,
                                      dotAll: true)
                                  .hasMatch(value)) {
                                return 'Invalid Input';
                              }

                              return null;
                            }, (value) {}),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: customTextField(
                                        TextInputType.text,
                                        'Middle Initial',
                                        txtMiddleName,
                                        useMobileLayout,
                                        'Please enter your Middle Name',
                                        (value) {
                                      return null;
                                    }, (value) {
                                      if (value.toString().length > 2) {
                                        setState(() {
                                          txtMiddleName.text =
                                              value.toString().substring(0, 2);
                                        });
                                      }
                                    }
                                        //     (value) {
                                        //   if (value!.isEmpty) {
                                        //     return 'Please enter your Middle Name';
                                        //   }

                                        //   if (!RegExp(r"^[\p{L} ,.'-]*$",
                                        //           caseSensitive: false,
                                        //           unicode: true,
                                        //           dotAll: true)
                                        //       .hasMatch(value)) {
                                        //     return 'Invalid Input';
                                        //   }
                                        //   return null;
                                        // }
                                        ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: customTextFieldDisable(
                                        TextInputType.number,
                                        'Age',
                                        txtAge,
                                        useMobileLayout,
                                        'Please enter your Age',
                                        //     (value) {
                                        //   return null;
                                        // }
                                        (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your Age';
                                      }

                                      // if (!RegExp(r"^[\p{L} ,.'-]*$",
                                      //         caseSensitive: false,
                                      //         unicode: true,
                                      //         dotAll: true)
                                      //     .hasMatch(value)) {
                                      //   return 'Invalid Input';
                                      // }
                                      return null;
                                    }, (value) {
                                      if (value.toString().length > 2) {
                                        setState(() {
                                          txtAge.text =
                                              value.toString().substring(0, 2);
                                        });
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            //                           customTextField('Middle Name', txtMiddleName,
                            //                               useMobileLayout, 'Please enter your Middle Name'),
                            customTextField(
                                TextInputType.text,
                                'Last Name',
                                txtLastName,
                                useMobileLayout,
                                'Please enter your Last Name', (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Last Name';
                              }

                              if (!RegExp(r"^[\p{L} ,.'-]*$",
                                      caseSensitive: false,
                                      unicode: true,
                                      dotAll: true)
                                  .hasMatch(value)) {
                                return 'Invalid Input';
                              }
                              return null;
                            }, (value) {}),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            CustomDateTime(
                              title: "",
                              controller: txtBirthday,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  // final f = new DateFormat('yyyy-MM-dd');
                                  final f = new DateFormat('MMMM dd, yyyy');
                                  txtBirthday.text = f.format(value).toString();
                                  // print(value);
                                  // return txtEnterDate.text;
                                });
                                // FocusScope.of(context)
                                //     .requestFocus(ctcNumberFocus);
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  DateTime now = DateTime.now();
                                  Duration age = now.difference(value!);
                                  int years = age.inDays ~/ 365;
                                  setState(() {
                                    txtAge.text = years.toString();
                                  });
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  // final f = new DateFormat('yyyy-MM-dd');
                                  final f = new DateFormat('MMMM dd, yyyy');
                                  // txtBirthday.text = val.toString();
                                  txtBirthday.text = f.format(val).toString();
                                  // print("ONSAVE" +
                                  //     txtBirthday.text);
                                });
                              },
                              validator: (value) {
                                if (value == null && txtBirthday.text.isEmpty) {
                                  // print(txtEnterDateFrom.text);
                                  return 'Please enter date';
                                }
                                return null;
                              },
                              focusNode: lastNameFocus,
                            ),
                            customTextField(
                                TextInputType.text,
                                'Email Address',
                                txtEmail,
                                useMobileLayout,
                                'Please enter your Email', (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email Address';
                              }

                              if (!RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(value)) {
                                return 'Invalid Email Address';
                              }
                              // if (!RegExp(r"^[\p{L} ,.'-]*$",
                              //         caseSensitive: false,
                              //         unicode: true,
                              //         dotAll: true)
                              //     .hasMatch(value)) {
                              //   return 'Invalid Input';
                              // }
                              return null;
                            }, (value) {}),
                            customTextField(
                                TextInputType.text,
                                'Brgy Address',
                                txtBrgyAddress,
                                useMobileLayout,
                                'Please enter your Email', (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Brgy Address';
                              }

                              // if (!RegExp(
                              //         r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              //     .hasMatch(value)) {
                              //   return 'Invalid Email Address';
                              // }
                              // if (!RegExp(r"^[\p{L} ,.'-]*$",
                              //         caseSensitive: false,
                              //         unicode: true,
                              //         dotAll: true)
                              //     .hasMatch(value)) {
                              //   return 'Invalid Input';
                              // }
                              return null;
                            }, (value) {}),
                            customTextField(
                                TextInputType.number,
                                'Mobile Number (09XXXXXXXXX)',
                                txtContactNumber,
                                useMobileLayout,
                                'Please enter your contact number', (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Contact Number';
                              }

                              if (txtContactNumber.text.toString().length !=
                                  11) {
                                return 'Invalid Number';
                              }
                              return null;
                            }, (value) {}),
                            mypassword('', Icons.password, txtPassword,
                                useMobileLayout),
                            confirmpassword("", Icons.password,
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
                                    child: Text.rich(
                                  TextSpan(
                                      text: "I agree the ",
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "Terms and Conditions and Privacy Policy",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.yellow),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showTermsAndConditions();
                                              })
                                      ]),
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ))
                              ],
                            )),
                            isCheckedLoad
                                ? (!isChecked
                                    ? Text(
                                        "Please check terms and conditions",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.redAccent[200],
                                          ),
                                        ),
                                      )
                                    : Container())
                                : Container(),

                            // Card(
                            //   elevation: 5,
                            //   child: SizedBox(
                            //     height: 100,
                            //     child: Row(
                            //       children: <Widget>[
                            //         Checkbox(
                            //             value: isNotARobot,
                            //             onChanged: (bool? value) {
                            //               _openReCaptcha();
                            //             }),
                            //         const Expanded(
                            //           child: Text("I'm not a robot"),
                            //         ),
                            //         const SizedBox(
                            //           width: 5,
                            //         ),
                            //         Container(
                            //           alignment: Alignment.centerRight,
                            //           child: Image.asset(
                            //             'assets/images/captcha.jpg',
                            //             width: 80,
                            //             height: 80,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // isCheckedLoad
                            //     ? (!isNotARobot
                            //         ? Text(
                            //             "Please check not a robot",
                            //             style: GoogleFonts.poppins(
                            //               textStyle: TextStyle(
                            //                 fontSize: 12,
                            //                 color: Colors.redAccent[200],
                            //               ),
                            //             ),
                            //           )
                            //         : Container())
                            //     : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            //                           mypassword(
                            //                               "", Icons.lock, txtPassword, useMobileLayout),
                            //                           confirmpassword("", Icons.lock, txtConfirmPassword,
                            //                               useMobileLayout),
                            // Proceed(proceed),
                            signUpButton(useMobileLayout),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: useMobileLayout ? null : 500,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Already have an account?',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: useMobileLayout
                                              ? 16
                                              : 18, // tablet
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushReplacementNamed(
                                              Login.routeName),
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize:
                                                  useMobileLayout ? 16 : 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.amberAccent),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
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
      ),
    );
  }

  UnderlineInputBorder _textFormBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff088181),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Container customTextField(
      TextInputType inputType,
      String hintTextP,
      TextEditingController control,
      bool useMobileLayout,
      String validator,
      String? Function(String?)? validate,
      String? Function(String?)? onChange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              keyboardType: inputType,
              obscureText: hintTextP != "" ? false : _hidePassword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: useMobileLayout ? 16 : 18,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                    color: Colors.redAccent[200],
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: hintTextP == ""
                    ? IconButton(
                        icon: _hidePassword
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibilityConfirm,
                      )
                    : null,
              ),
              validator: validate,
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }

  Container customTextFieldDisable(
      TextInputType inputType,
      String hintTextP,
      TextEditingController control,
      bool useMobileLayout,
      String validator,
      String? Function(String?)? validate,
      String? Function(String?)? onChange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              keyboardType: inputType,
              obscureText: hintTextP != "" ? false : _hidePassword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: useMobileLayout ? 16 : 18,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: false,
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
                    color: Colors.redAccent[200],
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: hintTextP == ""
                    ? IconButton(
                        icon: _hidePassword
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibilityConfirm,
                      )
                    : null,
              ),
              validator: validate,
              onChanged: onChange,
            ),
          ),
        ],
      ),
    );
  }

  Container mypassword(String hintTextP, IconData preIcon,
      TextEditingController control, bool useMobileLayout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: true,
                hintText: "Password",
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent[200],
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
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : const Icon(
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
                  return 'Please enter Password';
                }

                if (value.toString().length < 8) {
                  return 'Password must be 8 character';
                }

                if (txtPassword.text.toString() !=
                    txtConfirmPassword.text.toString()) {
                  return 'Confirm password not match';
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
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              obscureText: hintTextP != "" ? false : _hideConfirmPassword,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabled: true,
                hintText: "Confirm Password",
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent[200],
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
                        icon: _hideConfirmPassword
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                // size: useMobileLayout ? 15 : 18,
                                size: 20,
                              ),
                        onPressed: toggleVisibilityConfirm,
                      )
                    : null,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Confirm Password';
                }

                if (value.toString().length < 8) {
                  return 'Password must be 8 character';
                }

                if (txtPassword.text.toString() !=
                    txtConfirmPassword.text.toString()) {
                  return 'Password not match';
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
      backgroundColor: const Color(0xff404747),
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
            setState(() {
              isCheckedLoad = true;
            });
            if (!_formKey.currentState!.validate()) {
              return;
            } else {
              setState(() {
                _isLoading = true;
              });
              checkUserCreds(context);
              // sendOTP(context);
              // _determinePosition();
              // _getMacAddress();
            }
            // sendOTP(context);
          }, // your tap handler moved here
          builder: (context, onTap) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 255, 255, 0), // foreground
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(50.0),
              // ),
              onPressed: _isLoading ? null : onTap,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "SIGN UP",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: useMobileLayout ? 16 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
