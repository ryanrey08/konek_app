// Packages and Libraries
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//Widget
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dashboard.dart';
import '../features/Widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'pos.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isKeptOn = false;
  double _brightness = 1.0;
  static int _currentPage = 0;
  int _currentIndex = 0;

  PageController _controller = PageController(
    initialPage: _currentPage,
  );

  var user;
  var farmer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //getUser();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extracteduserData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;
    setState(() {
      if (extracteduserData['data'] == null) {
        farmer = extracteduserData;
      } else {
        farmer = extracteduserData['data'];
        print(farmer);
      }
      isLoading = true;
    });
  }

  void enterVoucherCode() {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Enter Voucher Code',
              // style: Theme.of(context).textTheme.titleLarge,
              style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 55, 57, 175),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: 'Voucher Code',
                  //prefixIcon: Icon(Icons.code),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              isFixedHeight: false,
              text: 'OK',
              color: Color.fromARGB(255, 55, 57, 175),
              pressEvent: () {
                dialog.dismiss();
              },
            )
          ],
        ),
      ),
    );

    dialog.show();
  }

  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      decoration: BoxDecoration(
        // color: Colors.grey[200],

        image: DecorationImage(
          image: const AssetImage('assets/images/connections-clipart-md.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   stops: [0.1, 0.8],
        //   colors: [Colors.white, Colors.green[400]],
        // ),
      ),
      child: SingleChildScrollView(
        //padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              width: useMobileLayout ? 300 : 350,
              height: useMobileLayout ? 200 : 250,
              decoration: BoxDecoration(
                //  color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/novulutions.png'),
                ),
              ),
              child: Column(children: [
                SizedBox(
                  height: 45,
                ),
                Expanded(
                  child: Text(
                    "WELCOME",
                    style: GoogleFonts.poppins(
                        fontSize: 50,
                        color: Color.fromARGB(255, 55, 57, 175),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //      Text(
                //   "John Doe",
                //   style: GoogleFonts.poppins(
                //       fontSize: 30, color: Color.fromARGB(255, 55, 57, 175),fontWeight: FontWeight.bold),
                // )
              ]),
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 4,
                      color: Colors.white.withOpacity(0.8),
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        // height:  150,
                        //width: double.infinity,
                        width: useMobileLayout ? null : 700,
                        //width: 500,
                        height: useMobileLayout ? 110 : 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 55, 57, 175)),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: Text(
                                      'MY ACCOUNT',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: useMobileLayout ? 14 : 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '1 Day/s',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: useMobileLayout ? 18 : 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Remaining',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: useMobileLayout ? 18 : 30,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(children: [
                                Icon(
                                  Icons.wifi,
                                  size: useMobileLayout ? 60 : 70,
                                  color: Colors.greenAccent,
                                ),
                                Container(
                                  child: Row(children: [
                                    Text(
                                      "Status: ",
                                      style: GoogleFonts.poppins(
                                          fontSize: useMobileLayout ? 18 : 30,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Online",
                                      style: GoogleFonts.poppins(
                                          fontSize: useMobileLayout ? 18 : 30,
                                          color: Colors.greenAccent),
                                    )
                                  ]),
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 4,
                      color: Colors.white.withOpacity(0.8),
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        // height:  150,
                        //width: double.infinity,
                        width: useMobileLayout ? null : 700,
                        //height: useMobileLayout ? 90 : 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // SizedBox(height: 10),
                                        SizedBox(
                                          width: useMobileLayout ? 130 : 180,
                                          height: 50,
                                          child: ElevatedButton(
                                            child: Text(
                                              //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                              "1 Day",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      useMobileLayout ? 14 : 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              primary: Color.fromARGB(
                                                  255, 55, 57, 175), // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, POS.routeName);
                                            },
                                            // color: Colors.white,
                                            // textColor: Colors.black,
                                            // splashColor: Colors.yellowAccent[800],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "1 Day Unlimited All Surf Data for P50",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize:
                                                    useMobileLayout ? 12 : 30,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // SizedBox(height: 10),
                                        SizedBox(
                                          width: useMobileLayout ? 130 : 180,
                                          height: 50,
                                          child: ElevatedButton(
                                            child: Text(
                                              //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                              "5 Days",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      useMobileLayout ? 14 : 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              primary: Color.fromARGB(
                                                  255, 55, 57, 175), // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, POS.routeName);
                                            },
                                            // color: Colors.white,
                                            // textColor: Colors.black,
                                            // splashColor: Colors.yellowAccent[800],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "5 Days Unlimited All Surf Data for P250",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize:
                                                    useMobileLayout ? 12 : 30,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // SizedBox(height: 10),
                                        SizedBox(
                                          width: useMobileLayout ? 130 : 180,
                                          height: 50,
                                          child: ElevatedButton(
                                            child: Text(
                                              //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                              "15 Days",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      useMobileLayout ? 14 : 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              primary: Color.fromARGB(
                                                  255, 55, 57, 175), // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, POS.routeName);
                                            },
                                            // color: Colors.white,
                                            // textColor: Colors.black,
                                            // splashColor: Colors.yellowAccent[800],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "15 Days Unlimited All Surf Data for P550",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize:
                                                    useMobileLayout ? 12 : 30,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // SizedBox(height: 10),
                                        SizedBox(
                                          width: useMobileLayout ? 130 : 180,
                                          height: 50,
                                          child: ElevatedButton(
                                            child: Text(
                                              //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                              "30 Days",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      useMobileLayout ? 14 : 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              primary: Color.fromARGB(
                                                  255, 55, 57, 175), // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, POS.routeName);
                                            },
                                            // color: Colors.white,
                                            // textColor: Colors.black,
                                            // splashColor: Colors.yellowAccent[800],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "30 Days Unlimited All Surf Data for P1000",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize:
                                                    useMobileLayout ? 12 : 30,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Card(
                  //   elevation: 4,
                  //   color: Colors.white.withOpacity(0.8),
                  //   margin: EdgeInsets.all(8),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Container(
                  //     // height:  150,
                  //     //width: double.infinity,
                  //     width: useMobileLayout ? 600 : 700,

                  //     //height: useMobileLayout ? 90 : 150,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white,
                  //     ),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  //     child: Container(
                  //       child: SizedBox(
                  //         width: useMobileLayout ? 130 : 180,
                  //         height: 50,
                  //         child: ElevatedButton(
                  //           child: Text(
                  //             //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                  //             "VOUCHER CODE",
                  //             style: GoogleFonts.poppins(
                  //               textStyle: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: useMobileLayout ? 14 : 25,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ),
                  //           style: ElevatedButton.styleFrom(
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(50.0),
                  //             ),
                  //             primary: Color.fromARGB(
                  //                 255, 55, 57, 175), // background
                  //             onPrimary: Colors.white, // foreground
                  //           ),
                  //           onPressed: () {
                  //             enterVoucherCode();
                  //           },
                  //           // color: Colors.white,
                  //           // textColor: Colors.black,
                  //           // splashColor: Colors.yellowAccent[800],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Card(
                    elevation: 4,
                    color: Colors.white.withOpacity(0.8),
                    //margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      // height:  150,
                      width: double.infinity,
                      //width: useMobileLayout ? 600 : 700,

                      //height: useMobileLayout ? 90 : 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      // padding:
                      //     EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          // color: Colors.grey[200],

                          image: DecorationImage(
                            image: const AssetImage(
                                'assets/images/building.png'),
                            fit: BoxFit.cover,
                            // colorFilter: ColorFilter.mode(
                            //   Colors.black.withOpacity(0.2),
                            //   BlendMode.dstATop,
                            // ),
                          ),
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   stops: [0.1, 0.8],
                          //   colors: [Colors.white, Colors.green[400]],
                          // ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPersonCode() async {
    SharedPreferences sharedPreferences;

    sharedPreferences = await SharedPreferences.getInstance();

    final extractedUserData =
        json.decode(sharedPreferences.getString('userData')!)
            as Map<String, Object>;

    print(extractedUserData['personCode']);
    return extractedUserData['personCode'];
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final int index;
  final int currentIndex;
  final Function onPressed;

  const TabButton(
      {Key? key,
      required this.title,
      required this.index,
      required this.currentIndex,
      required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    return TextButton(
      child: Column(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: useMobileLayout ? 10 : 15,
              fontWeight: FontWeight.w600,
              color: currentIndex == index ? Colors.red : Colors.grey[850],
            ),
          ),
          Container(
            height: 2,
            width: 35,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
      onPressed: onPressed(),
    );
  }
}

class ItemDetails extends StatelessWidget {
  ItemDetails(this.title, this.value);

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: title.toUpperCase(),
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
