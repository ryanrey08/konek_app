// Packages and Libraries

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/config/httpexception.dart';
import 'package:konek_app/features/widgets.dart';
import 'package:konek_app/profile/providers/profileprovider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// Screens
import 'Register.dart';
import '../providers/auth.dart';
import './Login.dart';

/* <======= END =======>*/

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const routeName = '/forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _form = GlobalKey<FormState>();

  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "+639#########", filter: {"#": RegExp(r'[0-9]')});
  // SystemChrome.setEnabledSystemUIOverlays([]);

  TextEditingController _numberContoller = TextEditingController();
  TextEditingController _otpcode = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  bool _isInit = false;

  bool isOtpValid = false;

  bool isCheckNumber = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  Future<void> _showDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here

              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Error in changing password!\n' +
                              'Reach maximum counts of change password request. You can only change your password once a month. If you need help please contact our support.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 130,
                      ),
                    ],
                  )),
                ),
              ));
        });
  }

  Future<void> checkUserExists() async {
    setState(() {
      isCheckNumber = true;
    });
    var data;
    try {
      data = await Provider.of<Auth>(context, listen: false)
          .checkUserExists(_numberContoller.text);
      if (data['success']) {
        // ignore: use_build_context_synchronously
        Alert(
            context: context,
            onWillPopActive: true,
            title: "To ensure the security of your account, we have sent a verification code to " +
                data['data'] +
                ". Please check your email and enter the code in the field below to verify your email address and proceed with the process.",
            style: AlertStyle(
                titleStyle:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            content: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(bottom: 5),
                    child: Row(
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
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 50),
                                errorText: isOtpValid ? 'Invalid Code' : null,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buttons: [
              DialogButton(
                color: Color.fromARGB(255, 55, 57, 175),
                onPressed: () async {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(Dashboard.routeName);
                  // updateMyPassword();
                  print(_otpcode.text);
                  print(data['digitCode']);
                  if (_otpcode.text == data['digitCode']) {
                    changePassword();
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
          desc: "Number does not exist",
          btnOkOnPress: () {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // print(_selectedProvince);
          },
        ).show();
      }

      setState(() {
        isCheckNumber = false;
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

  void changePassword() {
    Alert(
        context: context,
        title: "",
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              // Text(
              //   'The OTP password was sent to the following recipient:',
              //   textAlign: TextAlign.center,
              //   style: GoogleFonts.poppins(
              //     color: Colors.black,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: txtNewPassword,
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
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
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
                            borderSide: BorderSide(
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
                          hintText: 'Enter New Password',
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
                            return 'Please enter the password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: txtConfirmPassword,
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
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
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
                            borderSide: BorderSide(
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
                          hintText: 'Enter Confirm Password',
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
                            return 'Please enter confirm password';
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
            color: Color.fromARGB(255, 55, 57, 175),
            onPressed: () async {
              // Navigator.of(context)
              //     .pushReplacementNamed(Dashboard.routeName);
              updateMyPassword();
            },
            child: Text(
              "Change Password",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]).show();
  }

  void updateMyPassword() async {
    var userInfo = {
      'mobile_number': _numberContoller.text,
      'new_password': txtNewPassword.text,
      'confirm_password': txtConfirmPassword.text,
    };
    try {
      bool isSaved = await Provider.of<Auth>(context, listen: false)
          .changePassword(userInfo);
      if (isSaved) {
        // setState(() {
        //   isLoadingSend = false;
        // });
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          onDismissCallback: (BuildContext) {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: "Change Password",
          desc: "Successfully Changed Password",
          btnOkOnPress: () {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // print(_selectedProvince);
            Navigator.of(context).pushReplacementNamed(
              Login.routeName,
            );
          },
        ).show();

        // setState(() {
        //   _currentStep += 1;
        // });
      }
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
      print(error);
      if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
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

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 55, 57, 175),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon:
                    const Icon(Icons.keyboard_arrow_left, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, Login.routeName);
                } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
          }),
          automaticallyImplyLeading: false,
          title: Text('Forgot Password',
              style: GoogleFonts.poppins(
                  fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
        ),
        body: Center(
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                // padding: EdgeInsets.only(left: 50, right: 50),
                padding: EdgeInsets.symmetric(
                  // vertical: useMobileLayout ? 30 : 60,
                  horizontal: useMobileLayout ? 50 : 150,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Container(
                    //   padding: EdgeInsets.only(bottom: 30),
                    //   child: SvgPicture.asset(
                    //     'assets/svg/phone_number.svg',
                    //     width: 200,
                    //     fit: BoxFit.fitHeight,
                    //   ),
                    // ),
                    // SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Verify Mobile Number',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: useMobileLayout ? 30 : 30,
                                color: Colors.black)),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Please enter your phone number to verify your account and proceed with the password reset process.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    // SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: TextFormField(
                        // autofocus: true,
                        controller: _numberContoller,
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          fillColor: Colors.white,
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(25.0),
                          //   borderSide: BorderSide(),
                          // ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 55, 57, 175),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 55, 57, 175),
                            ),
                          ),
                          labelStyle: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                  color: Color.fromARGB(255, 55, 57, 175),
                                  fontSize: 18)),

                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.0),
                          prefixIcon: const Icon(
                            Icons.phone_android,
                            color: Color.fromARGB(255, 55, 57, 175),
                          ),
                          //fillColor: Colors.green
                        ),
                        // inputFormatters: [maskTextInputFormatter],
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null) {
                            return 'Please provide a value.';
                          }
                          // if (value.length < 13) {
                          //   return 'Invalid Number';
                          // }
                          return null;
                        },
                        onChanged: (value) {
                          // setState(() {
                          //   value += '+63';
                          // });
                        },
                      ),
                    ),
                    // SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: useMobileLayout ? 50 : 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            textStyle: const TextStyle(
                              color: Colors.green,
                              decorationColor: Colors.black,
                            )),
                        onPressed: isCheckNumber
                            ? null
                            : () {
                                if (!_form.currentState!.validate()) {
                                  return;
                                } else {
                                  setState(() {
                                    _otpcode.text = '';
                                    isOtpValid = false;
                                  });
                                  checkUserExists();
                                }
                              },
                        child: Text(
                          "Proceed".toUpperCase(),
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: useMobileLayout ? 14 : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Text(
                        //   'Don\'t have any account?',
                        //   style: GoogleFonts.nunito(
                        //       textStyle: TextStyle(
                        //           fontSize: useMobileLayout ? 13 : 13,
                        //           color: Colors.black)),
                        // ),
                        // FlatButton(
                        //   onPressed: () => Navigator.of(context)
                        //       .pushReplacementNamed(Register.routeName),
                        //   child: Text(
                        //     'Register',
                        //     style: GoogleFonts.nunito(
                        //         textStyle: TextStyle(
                        //             fontSize: useMobileLayout ? 13 : 13,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.green)),
                        //   ),
                        // ),
                      ],
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
}
