import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/auth/screens/login.dart';
import 'package:konek_app/features/widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: useMobileLayout ? 16 : 18,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 55, 57, 175),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    // await Provider.of<Auth>(context, listen: false).logout();
                    // Navigator.of(context).pushReplacementNamed(Login.routeName);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        // body: pages[_currentIndex],
        body: Container(),
        bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                // _currentIndex = index;
                // _pageTitle = pageTitle[index];
                // print(index.toString());
              });
            },
            backgroundColor: Color.fromARGB(255, 55, 57, 175),
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  size: 20,
                  color: Colors.white,
                ),
                label: "Home"
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
                icon: new Icon(
                  Icons.list,
                  size: 20,
                  color: Colors.white,
                ),
                label: "Application"
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
              //     Icons.report,
              //     size: 20,
              //     color: Colors.white,
              //   ),
              //   title: Text(
              //     'Reports',
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
          ),
        ),

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
                        Container(
                          height: 180,
                          child: Theme(
                            data: ThemeData(dividerColor: Colors.transparent),
                            child: DrawerHeader(
                              decoration: BoxDecoration(color: Color.fromARGB(255, 55, 57, 175)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 90,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/novulutions.png'),
                                      ),
                                      // border: Border.all(color: Colors.grey),
                                      // borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
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
                          margin: EdgeInsets.symmetric(
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
                                  // Navigator.of(context).pushReplacementNamed(
                                  //     MyProfile.routeName);
                                }, color: Colors.white,
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
                              Divider(),

                              Container(
                                margin: EdgeInsets.symmetric(
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
                                    //         listen: false)
                                    //     .logout();
                                    // Navigator.of(context).pushNamedAndRemoveUntil(
                                    //     Login.routeName,
                                    //     (Route<dynamic> route) => false);

                                    Navigator.of(context)
                                        .pushReplacementNamed(Login.routeName);
                                  }, color: Colors.white,
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
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Text(
                      "v4.1",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
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
    );
  }
}
