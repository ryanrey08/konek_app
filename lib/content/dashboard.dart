import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/auth/providers/auth.dart';
import 'package:konek_app/auth/screens/login.dart';
import 'package:konek_app/config/config.dart';
import 'package:konek_app/config/notification.dart';
import 'package:konek_app/content/network.dart';
import 'package:konek_app/content/notification.dart';
import 'package:konek_app/content/uploadpic.dart';
import 'package:konek_app/features/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import './home.dart';
import '../profile/screens/profile.dart';
import './transaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? _currentIndex;
  String? _pageTitle;

  final tabs = [
    HomePage(),
    const UploadPicture(),
    const Transaction()
    // const MyNetwork(),
    // ReportPage(),
    // MiscPage(),
    // ComponentsPage()
  ];

  var pageTitle = ["Home", "Scan/Upload QR", "Transaction"];
  bool isLoading = false;
  String? fullName;

  var voucherData;

  late Preference<String> globalVoucherData;

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageTitle = pageTitle[0];
    // startTime();
    //assignData();
    showLoading();
    getStreamData();
    NotificationController.startListeningNotificationEvents();
    //getVoucherData();
  }

  getStreamData() async {
    final preferences = await StreamingSharedPreferences.instance;

    setState(() {
      globalVoucherData = preferences.getString('voucherData',
          defaultValue:
              '{ "voucher_code": "","duration": 0,"description": "","amount": 0,"claimed_date": "","expire_date": "","status": ""}');
      isLoading = true;
    });
  }

  assignData() async {
    voucherData = {
      "voucher_code": "",
      "duration": 0,
      "description": "",
      "amount": 0,
      "claimed_date": "",
      "expire_date": "",
      "status": ""
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('voucherData', json.encode(voucherData));
  }

  void getVoucherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('voucherData')) {
      voucherData = {
        "voucher_code": "",
        "duration": 0,
        "description": "",
        "amount": 0,
        "claimed_date": "",
        "expire_date": "",
        "status": ""
      };
    } else {
      final extracteduserData =
          json.decode(prefs.getString('voucherData')!) as Map<String, dynamic>;
      print(extracteduserData);

      setState(() {
        voucherData = extracteduserData;
      });
    }

    setState(() {
      isLoading = true;
    });

    // prefs.clear();
  }

  showLoading() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    final sharedPreferences = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(sharedPreferences.getString('userData')!) as Map;
    if(extractedUserData['data']['user'] != null){
          fullName = extractedUserData['data']['user']['first_name'] +
        " " +
        extractedUserData['data']['user']['last_name'];
    }else{
          fullName = extractedUserData['data']['first_name'] +
        " " +
        extractedUserData['data']['last_name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              _pageTitle!,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: useMobileLayout ? 16 : 18,
                  color: Colors.white
                ),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color.fromARGB(255, 55, 57, 175),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      // await Provider.of<Auth>(context, listen: false).logout();
                      // Navigator.of(context).pushReplacementNamed(Login.routeName);
                      Navigator.of(context)
                          .pushReplacementNamed(NotificationList.routeName);
                    },
                    child: const Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          // body: pages[_currentIndex],
          body: tabs[_currentIndex!],
          bottomNavigationBar: !isLoading
              ? BottomAppBar(
                height: 70,
                padding: EdgeInsets.zero,
                color: const Color.fromARGB(255, 55, 57, 175),
                  child: PreferenceBuilder<String>(
                      preference: globalVoucherData,
                      builder: (context, vouchData) {
                        var newVoucherData = json.decode(vouchData);
                        return BottomNavigationBar(
                          // selectedItemColor: Colors.white,
                          // unselectedItemColor: Colors.black,
                          type: BottomNavigationBarType.fixed,
                          onTap: (index) {
                            setState(() {
                              if (newVoucherData['status'] == 'completed') {
                                if (index == 1) {
                                  _currentIndex = _currentIndex;
                                } else {
                                  _currentIndex = index;
                                  _pageTitle = pageTitle[index];
                                }
                              } else {
                                _currentIndex = index;
                                _pageTitle = pageTitle[index];
                              }
                              print(index.toString());
                            });
                          },
                          backgroundColor: const Color.fromARGB(255, 55, 57, 175),
                          currentIndex: 0,
                          items: [
                            BottomNavigationBarItem(
                                icon: const Icon(
                                  Icons.home,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: ""
                                // title: Text(
                                //   'Home',
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //       fontSize: 10,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                // backgroundColor: Colors.green[50],
                                ),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.qr_code,
                                  size: 30,
                                  // color: Colors.white,
                                  color: !isLoading
                                      ? (newVoucherData['status'] == 'completed'
                                          ? Colors.redAccent
                                          : Colors.white)
                                      : Colors.white,
                                ),
                                label: ""
                                // backgroundColor: Colors.green[50],
                                ),
                            BottomNavigationBarItem(
                                icon: const Icon(
                                  Icons.list,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: ""
                                // title: Text(
                                //   'Application',
                                //   style: GoogleFonts.poppins(
                                //     textStyle: TextStyle(
                                //       fontSize: 13,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                // backgroundColor: Colors.green[50],
                                ),
                            // BottomNavigationBarItem(
                            //   icon: new Icon(
                            //     Icons.star,
                            //     size: 20,
                            //     color: Colors.white,
                            //   ),
                            //   title: Text(
                            //     'Misc',
                            //     style: GoogleFonts.poppins(
                            //       textStyle: TextStyle(
                            //         fontSize: 13,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            //   // backgroundColor: Colors.green[50],
                            // ),
                            // BottomNavigationBarItem(
                            //   icon: new Icon(
                            //     Icons.settings_applications,
                            //     size: 20,
                            //     color: Colors.white,
                            //   ),
                            //   title: Text(
                            //     'Components',
                            //     style: GoogleFonts.poppins(
                            //       textStyle: TextStyle(
                            //         fontSize: 13,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            //   // backgroundColor: Colors.green[50],
                            // )
                          ],
                        );
                        // return NavigationBar(
                        //   onDestinationSelected: (int index) {
                        //     setState(() {
                        //       currentPageIndex = index;
                        //     });
                        //   },
                        //   backgroundColor: Color.fromARGB(255, 55, 57, 175),
                        //   indicatorColor: Colors.amber,
                        //   selectedIndex: currentPageIndex,
                        //   destinations: const <Widget>[
                        //     NavigationDestination(
                        //       selectedIcon: Icon(Icons.home, color: Colors.white,),
                        //       icon: Icon(Icons.home_outlined, color: Colors.white),
                        //       label: 'Home',
                        //     ),
                        //     NavigationDestination(
                        //       icon: Badge(child: Icon(Icons.notifications_sharp)),
                        //       label: 'Notifications',
                        //     ),
                        //     NavigationDestination(
                        //       icon: Badge(
                        //         label: Text('2'),
                        //         child: Icon(Icons.messenger_sharp),
                        //       ),
                        //       label: 'Messages',
                        //     ),
                        //   ],
                        // );
                      }),
                )
              : Container(child: const Center(child: CircularProgressIndicator())),
      
          drawer: Container(
            color: Colors.white,
            width: useMobileLayout ? 250 : 300,
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 180,
                            child: Theme(
                              data: ThemeData(dividerColor: Colors.transparent),
                              child: DrawerHeader(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 55, 57, 175)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 90,
                                      width: 180,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/swak-img.png'),
                                        ),
                                        // border: Border.all(color: Colors.grey),
                                        // borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    Text(
                                      fullName.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                    // isLoading
                                    //     ?
                                    //     Text(
                                    //    '',
                                    //         style: GoogleFonts.poppins(
                                    //           textStyle: TextStyle(
                                    //             fontSize: 14,
                                    //             color: Color(0xFF255946),
                                    //             fontWeight: FontWeight.w600,
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : Container(),
                                    // isLoading
                                    //     ? Text(farmer['rsbsa_no'] == null ? "---" : farmer['rsbsa_no'])
                                    //     : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Wrap(
                              children: <Widget>[
                                // DrawerOptions(
                                //   dense: true,
                                //   title: "BACOOR.GOV.PH",
                                //   useMobileLayout: useMobileLayout,
                                //   iconData: Icons.pageview,
                                //   onTapFunc: () {
                                //     _launchInBrowser('https://bacoor.gov.ph/');
                                //   },
                                // ),
                                // Divider(),
                                DrawerOptions(
                                  dense: true,
                                  title: "View Profile",
                                  useMobileLayout: useMobileLayout,
                                  iconData: Icons.account_box,
                                  onTapFunc: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        MyProfile.routeName);
                                  },
                                  color: Colors.white,
                                ),
      
                                // DrawerOptions(
                                //   dense: true,
                                //   title: "Account Setting",
                                //   useMobileLayout: useMobileLayout,
                                //   iconData: Icons.settings,
                                //   onTapFunc: () {
                                //     // Navigator.of(context).pushReplacementNamed(
                                //     //     TransactionPage.routeName);
                                //   },
                                // ),
                                //   DrawerOptions(
                                //   dense: true,
                                //   title: "Missions",
                                //   useMobileLayout: useMobileLayout,
                                //   iconData: Icons.flag,
                                //   onTapFunc: () {
                                //     // Navigator.of(context).pushReplacementNamed(
                                //     //     TransactionPage.routeName);
                                //   },
                                // ),
                                // DrawerOptions(
                                //   dense: true,
                                //   title: "Help",
                                //   useMobileLayout: useMobileLayout,
                                //   iconData: Icons.info,
                                //   onTapFunc: () {
                                //     // Navigator.of(context).pushReplacementNamed(
                                //     //     TransactionPage.routeName);
                                //   },
                                // ),
      
                                // DrawerOptions(
                                //   dense: true,
                                //   title: "Login Activity",
                                //   useMobileLayout: useMobileLayout,
                                //   iconData: Icons.history,
                                //   onTapFunc: () {
                                //     // Navigator.of(context).pushReplacementNamed(
                                //     //     TransactionPage.routeName);
                                //   },
                                // ),
                                const Divider(),
      
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[200],
                                  ),
                                  child: DrawerOptions(
                                    title: "Log Out",
                                    useMobileLayout: useMobileLayout,
                                    iconData: Icons.exit_to_app,
                                    onTapFunc: () async {
                                      // await Provider.of<Auth>(context,
                                      //         listen: false).logout();
                                      await Provider.of<Auth>(context,
                                              listen: false)
                                          .logout();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              Login.routeName,
                                              (Route<dynamic> route) => false);
      
                                      Navigator.of(context)
                                          .pushReplacementNamed(Login.routeName);
                                    },
                                    color: Colors.white,
                                    dense: false,
                                  ),
                                ),
      
                                // SizedBox(
                                //   height: useMobileLayout ? 100 : 150,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(
                        "",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      trailing: Text(
                        "v4.1",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
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
}
