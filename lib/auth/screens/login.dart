import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/auth/screens/register.dart';
import 'package:konek_app/content/dashboard.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _hidePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final txtUsernameController = TextEditingController();
  final txtPasswordController = TextEditingController();
  double appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: height,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('images/connections-clipart-md.png'),
            //   fit: BoxFit.cover,

            //   // colorFilter: ColorFilter.mode(
            //   //   Colors.black.withOpacity(0.2),
            //   //   BlendMode.dstATop,
            //   // ),
            // ),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.8],
                //colors: [CupertinoColors.systemBlue, CupertinoColors.systemPurple],
                //colors: [Colors.blue, Colors.purple]
                colors: [Colors.white, Colors.white]),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: useMobileLayout ? 430 : 550,
                    height: useMobileLayout ? 280 : 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/connection.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  //const SizedBox(height: 250),
                  Card(
                    elevation: 4,
                    //color: Colors.white.withOpacity(0.8),
                    color: const Color.fromARGB(255, 55, 57, 175),
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2 + 100,
                      width: useMobileLayout
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width - 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // SizedBox(height: 20),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "SIGN IN",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: useMobileLayout ? 18 : 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 100,
                                        height: 100,
                                        child: const Image(
                                          // image: NetworkImage(
                                          //     'assets/images/novulutions.png'),
                                          image: AssetImage(
                                              'assets/images/novulutions.png'),
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    loginEmailFields(
                                        "USERNAME/EMAIL",
                                        Icons.person_2,
                                        txtUsernameController,
                                        useMobileLayout),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    loginFields("", Icons.lock,
                                        txtPasswordController, useMobileLayout),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: GestureDetector(
                                            child: Text(
                                              'Forgot password?',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    // decoration: TextDecoration.underline,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) => ForgotPassword()),
                                              // );\
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    loginButton(useMobileLayout),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Don\'t have any account?',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize:
                                                  useMobileLayout ? 13 : 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    AccountRegister.routeName);
                                          },
                                          child: Text(
                                            'Register Here',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize:
                                                    useMobileLayout ? 13 : 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: Text(

                                    //     'v.1-staging',
                                    //     style: GoogleFonts.poppins(
                                    //       textStyle: TextStyle(
                                    //         // fontSize: useMobileLayout ? 13 : 18,
                                    //         fontSize: 12,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.bottomRight,
                  //   child: Text(
                  //  'v.1-Staging',
                  //     style: GoogleFonts.poppins(
                  //       textStyle: TextStyle(
                  //           // fontSize: useMobileLayout ? 13 : 18,
                  //           fontSize: 14,
                  //           color: Colors.white),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container loginEmailFields(String hintText, IconData preIcon,
      TextEditingController control, bool useMobileLayout) {
    return Container(
      // height: useMobileLayout ? 60 : 80,
      width: useMobileLayout ? null : 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: control,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: useMobileLayout ? 16 : 18, color: Colors.black),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: hintText,
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 55, 57, 175),
                ),
                // hintStyle: TextStyle(color: Colors.grey[400]),
                hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: useMobileLayout ? 16 : 18,
                      color: Colors.grey[400]),
                ),
                // enabledBorder: _textFormBorder(),
                // errorBorder: _textFormBorder(),
                // focusedErrorBorder: _textFormBorder(),
                // focusedBorder: _textFormBorder(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 55, 57, 175),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: CupertinoColors.systemGrey,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: CupertinoColors.systemGrey,
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
                errorStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: useMobileLayout ? 13 : 15,
                      color: Colors.red[900]),
                ),
                // helperText: "Enter you firstname",
                // helperStyle: GoogleFonts.poppins(
                //   textStyle: TextStyle(fontSize: 13, color: Colors.transparent),
                // ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number.';
                }
                // if (!value.contains('@')) {
                //   return 'Invalid username';
                // }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  UnderlineInputBorder _textFormBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Container loginFields(String hintTextP, IconData preIcon,
      TextEditingController control, bool useMobileLayout) {
    return Container(
      // height: useMobileLayout ? 60 : 80,
      width: useMobileLayout ? null : 500,
      child: TextFormField(
        controller: control,
        obscureText: hintTextP != "" ? false : _hidePassword,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: useMobileLayout ? 16 : 18, color: Colors.black),
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
              color: CupertinoColors.systemGrey,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: CupertinoColors.systemGrey,
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
              color: CupertinoColors.systemGrey,
              width: 1,
            ),
          ),
          errorStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: useMobileLayout ? 13 : 15, color: Colors.red[900]),
          ),
          // helperText: "Enter you firstname",
          // helperStyle: GoogleFonts.poppins(
          //   textStyle: TextStyle(fontSize: 13, color: Colors.transparent),
          // ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: "PASSWORD",
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromARGB(255, 55, 57, 175),
          ),
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: useMobileLayout ? 16 : 18, color: Colors.grey[400]),
          ),

          suffixIcon: hintTextP == ""
              ? IconButton(
                  icon: _hidePassword
                      ? Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          // size: useMobileLayout ? 15 : 18,
                          size: 22,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          // size: useMobileLayout ? 15 : 18,
                          size: 22,
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
    );
  }

  // Controls
  Container loginButton(bool useMobileLayout) {
    return Container(
      // height: useMobileLayout ? 50 : 70,
      height: 60,
      width: useMobileLayout ? null : 500,
      child: SizedBox.expand(
        child: TapDebouncer(
          onTap: () async {
            Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
          }, // your tap handler moved here
          builder: (BuildContext context, TapDebouncerFunc? onTap) {
            return ElevatedButton(
              child: Text(
                "SIGN IN",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: useMobileLayout ? 16 : 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  textStyle: const TextStyle(
                    color: Colors.green,
                    decorationColor: Colors.black,
                  )),
              onPressed: onTap,
            );
          },
        ),
      ),
    );
  }

  void toggleVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Future<void> signIn(String contact_number, String password) async {}
}
