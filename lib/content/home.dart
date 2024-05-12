// Packages and Libraries
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:konek_app/config/httpexception.dart';
import 'package:konek_app/config/notification.dart';
import 'package:konek_app/content/provider/content.dart';
import 'package:konek_app/content/provider/pos.dart';
import 'package:konek_app/content/provider/voucher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//Widget
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dashboard.dart';
import '../features/Widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:carousel_slider/carousel_slider.dart';
import 'pos.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isKeptOn = false;
  final double _brightness = 1.0;
  static final int _currentPage = 0;
  final int _currentIndex = 0;

  final PageController _controller = PageController(
    initialPage: _currentPage,
  );

  var user;
  var farmer;
  bool isLoading = false;
  var voucherData;

  late Preference<String> globalVoucherData;

  final List<Map<dynamic, dynamic>> imageLists = [
    {
      'title': 'PNP',
      'phone_number': '0932543543534',
      'image': 'assets/images/pnp_image.png'
    },
    {
      'title': 'PNP',
      'phone_number': '0932543543534',
      'image': 'assets/images/pnp_image.png'
    },
    {
      'title': 'PNP',
      'phone_number': '0932543543534',
      'image': 'assets/images/pnp_image.png'
    },
    {
      'title': 'PNP',
      'phone_number': '0932543543534',
      'image': 'assets/images/pnp_image.png'
    },
    {
      'title': 'PNP',
      'phone_number': '0932543543534',
      'image': 'assets/images/pnp_image.png'
    },
  ];

  final List<Map<dynamic, dynamic>> imgLists = [
    {
      'title': '',
      'image': 'assets/images/shoes.gif',
    },
    {
      'title': '',
      'image': 'assets/images/shoes2.gif',
    },
    {
      'title': '',
      'image': 'assets/images/cow.gif',
    },
    {
      'title': '',
      'image': 'assets/images/burger.gif',
    },
    {
      'title': '',
      'image': 'assets/images/ice_cream.gif',
    },
  ];

  final List<Map<dynamic, dynamic>> imgListsMandaue = [
    {
      'title': '',
      'image': 'assets/images/move_mandaue.jpg',
    },
    {
      'title': '',
      'image': 'assets/images/shoes.gif',
    },
    {
      'title': '',
      'image': 'assets/images/shoes2.gif',
    },
    {
      'title': '',
      'image': 'assets/images/cow.gif',
    },
    {
      'title': '',
      'image': 'assets/images/burger.gif',
    },
    {
      'title': '',
      'image': 'assets/images/ice_cream.gif',
    },
  ];

  List subscriptions = [
    {
      "id": 1,
      "name": "1 Day Surf",
      "price": "30.00",
      "duration": "1",
      "duration_unit": "day",
      "start_date": "2024-03-03 00:00:00",
      "end_date": "2024-04-27 00:00:00",
      "status": 1 // 1 = Active; 0 = Inactive
    },
    {
      "id": 1,
      "name": "1 Day Surf",
      "price": "30.00",
      "duration": "1",
      "duration_unit": "day",
      "start_date": "2024-03-03 00:00:00",
      "end_date": "2024-04-27 00:00:00",
      "status": 1 // 1 = Active; 0 = Inactive
    },
  ];
  List quickLinks = [];
  List ads = [];

  @override
  void initState() {
    super.initState();
    // assignData();
    //getUser();
    getVoucherData();
    getStreamData();
    refreshPage();
  }

  getStreamData() async {
    final preferences = await StreamingSharedPreferences.instance;

    setState(() {
      globalVoucherData = preferences.getString('voucherData',
          defaultValue:
              '{ "voucher_code": "","duration": 0,"description": "","amount": 0,"claimed_date": "","expire_date": "","status": ""}');
      // isLoading = true;
    });
  }

  getSubscription() async {
    var subscriptionsData =
        await Provider.of<Content>(context, listen: false).getSubscription();
    setState(() {
      subscriptions = subscriptionsData;
      //isLoading = false;
    });
  }

  getQuickLinks() async {
    var quickLinksData =
        await Provider.of<Content>(context, listen: false).getQuickLinks();
    setState(() {
      // quickLinks = quickLinksData;
      var newQuicklinks = [];
      // int arrLength = ((quickLinksData.length / 2) ~/ 1000);
      var myQuickLinks = [];
      for (var x = 0; x < quickLinksData.length; x++) {
        myQuickLinks.add(quickLinksData[x]);
        if (x % 2 == 1) {
          newQuicklinks.add(myQuickLinks);
          myQuickLinks = [];
        } else if (x == (quickLinksData.length - 1)) {
          newQuicklinks.add(myQuickLinks);
        }
      }
      quickLinks = newQuicklinks;
      // print(newQuicklinks);
      //isLoading = false;
    });
  }

  getAds() async {
    var adsData = await Provider.of<Content>(context, listen: false).getAds();
    setState(() {
      ads = adsData;
      //isLoading = false;
      print(ads);
    });
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
  }

  assignData(vouchData) async {
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
    prefs.setString('voucherData', json.encode(vouchData));
  }

  Future<void> getVoucherData() async {
    var errorMessage;
    // setState(() {
    //   isLoading = true;
    // });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey("swakPaymentRefNo")) {
    //   final extracteduserData = json
    //       .decode(prefs.getString('swakPaymentRefNo')!) as Map<String, dynamic>;
    //   print(extracteduserData['reference_number']);
    // }

    try {
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var vouchData = await Provider.of<POSProvider>(context, listen: false)
          .getMyPaymentStatus();

      setState(() {
        voucherData = vouchData;
      });
      // await UrlLauncher.launch(voucherData['url']);
      
      if (await Permission.notification.request().isGranted) {
        if (vouchData['status'] == 'completed') {
          // Future.delayed(const Duration(milliseconds: 3000), () {
          //   NotificationController.scheduleNewNotification(
          //       vouchData['description'], vouchData['expire_date']);
          // });
        }
        Future.delayed(const Duration(milliseconds: 3000), () async{
          print('notif here');
          await NotificationController.cancelNotifications();
          await NotificationController.scheduleNewNotification(
              vouchData['description'], vouchData['expire_date']);
        });
      }
      assignData(vouchData);
    } on HttpException catch (error) {
      print(error);
      showError(error.toString());
    } catch (error) {
      showError(error.toString());
    }
    // setState(() {
    //   isLoading = true;
    // });
  }

  // void getVoucherData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (!prefs.containsKey('voucherData')) {
  //     voucherData = {
  //       "voucher_code": "",
  //       "duration": 0,
  //       "description": "",
  //       "amount": 0,
  //       "claimed_date": "",
  //       "expire_date": "",
  //       "status": ""
  //     };
  //   } else {
  //     final extracteduserData =
  //         json.decode(prefs.getString('voucherData')!) as Map<String, dynamic>;
  //     print(extracteduserData);
  //     setState(() {
  //       voucherData = extracteduserData;
  //     });
  //   }

  //   // setState(() {
  //   //   isLoading = true;
  //   // });
  // }

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
                  color: const Color.fromARGB(255, 55, 57, 175),
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
              color: const Color.fromARGB(255, 55, 57, 175),
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

  refreshPage() async {
    setState(() {
      isLoading = false;
    });
    await getSubscription();
    await getQuickLinks();
    await getAds();
    await getVoucherData();
    await loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
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
      child: RefreshIndicator(
        onRefresh: () {
          return refreshPage();
        },
        child: SingleChildScrollView(
          //padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                width: useMobileLayout ? 300 : 350,
                height: useMobileLayout ? 130 : 180,
                decoration: const BoxDecoration(
                  //  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/swak-img.png'),
                  ),
                ),
                child: const Column(children: [
                  SizedBox(
                    height: 45,
                  ),
                  // Expanded(
                  //   child: Text(
                  //     "WELCOME",
                  //     style: GoogleFonts.poppins(
                  //         fontSize: 50,
                  //         color: Color.fromARGB(255, 55, 57, 175),
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  //      Text(
                  //   "John Doe",
                  //   style: GoogleFonts.poppins(
                  //       fontSize: 30, color: Color.fromARGB(255, 55, 57, 175),fontWeight: FontWeight.bold),
                  // )
                ]),
              ),
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? Column(
                        children: <Widget>[
                          PreferenceBuilder<String>(
                              preference: globalVoucherData,
                              builder: (context, vouchData) {
                                var newVoucherData = json.decode(vouchData);
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Card(
                                    elevation: 4,
                                    color: Colors.white.withOpacity(0.8),
                                    margin: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      // height:  150,
                                      //width: double.infinity,
                                      width: useMobileLayout ? null : 700,
                                      //width: 500,
                                      height: useMobileLayout ? 150 : 190,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              255, 55, 57, 175)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: Text(
                                                    'MY ACCOUNT',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize:
                                                            useMobileLayout
                                                                ? 12
                                                                : 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${isLoading ? (newVoucherData['status'] == 'completed' ? newVoucherData["duration"].toString() : "0") : "0"} Day/s",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontSize:
                                                            useMobileLayout
                                                                ? 16
                                                                : 28,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                      'Remaining',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize:
                                                              useMobileLayout
                                                                  ? 16
                                                                  : 28,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      minFontSize: 12,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Expanded(
                                          //   child: Column(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.start,
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     children: <Widget>[
                                          //       SizedBox(height: 10),
                                          //       SizedBox(
                                          //         height: 40,
                                          //       ),
                                          //       Expanded(
                                          //         child: Text(
                                          //           (isLoading
                                          //               ? "13.26 GB"
                                          //               : ""),
                                          //           textAlign: TextAlign.center,
                                          //           style: GoogleFonts.poppins(
                                          //             textStyle: TextStyle(
                                          //               fontSize:
                                          //                   useMobileLayout
                                          //                       ? 16
                                          //                       : 28,
                                          //               fontWeight:
                                          //                   FontWeight.w800,
                                          //               color: Colors.white,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Expanded(
                                          //         child: Text(
                                          //           'Data Spent',
                                          //           textAlign: TextAlign.center,
                                          //           style: GoogleFonts.poppins(
                                          //             textStyle: TextStyle(
                                          //               fontSize:
                                          //                   useMobileLayout
                                          //                       ? 16
                                          //                       : 28,
                                          //               fontWeight:
                                          //                   FontWeight.w800,
                                          //               color: Colors.white,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(children: [
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Icon(
                                                Icons.wifi,
                                                size: useMobileLayout ? 55 : 65,
                                                color: isLoading
                                                    ? (newVoucherData[
                                                                'status'] ==
                                                            'completed'
                                                        ? Colors.greenAccent
                                                        : Colors.redAccent)
                                                    : Colors.greenAccent,
                                              ),
                                              Container(
                                                child: Row(children: [
                                                  AutoSizeText("Status: ",
                                                      style: GoogleFonts.poppins(
                                                          fontSize:
                                                              useMobileLayout
                                                                  ? 16
                                                                  : 28,
                                                          color: Colors.white),
                                                      minFontSize: 12,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  AutoSizeText(
                                                      isLoading
                                                          ? (newVoucherData[
                                                                      'status'] ==
                                                                  'completed'
                                                              ? "Online"
                                                              : "Offline")
                                                          : 'Offline',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            useMobileLayout
                                                                ? 16
                                                                : 28,
                                                        color: isLoading
                                                            ? (newVoucherData[
                                                                        'status'] ==
                                                                    'completed'
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent)
                                                            : Colors
                                                                .greenAccent,
                                                      ),
                                                      minFontSize: 12,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]),
                                              ),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          PreferenceBuilder<String>(
                              preference: globalVoucherData,
                              builder: (context, vouchData) {
                                var newVoucherData = json.decode(vouchData);
                                return AbsorbPointer(
                                  absorbing: isLoading
                                      ? (newVoucherData['status'] == 'completed'
                                          ? true
                                          : false)
                                      : true,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      elevation: 4,
                                      color: Colors.white.withOpacity(0.8),
                                      margin: const EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        // height:  150,
                                        //width: double.infinity,
                                        width: useMobileLayout ? null : 700,
                                        //height: useMobileLayout ? 90 : 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // color: Colors.white,
                                          // color: Color(0xFF0E3311).withOpacity(0.5),
                                          color: isLoading
                                              ? (newVoucherData['status'] ==
                                                      'completed'
                                                  ? Colors.grey.withOpacity(0.5)
                                                  : Colors.white)
                                              : Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 15),
                                        child: Container(
                                          child: Column(
                                            children: subscriptions!.isNotEmpty
                                                ? <Widget>[
                                                    for (var x = 0;
                                                        x <
                                                            subscriptions
                                                                .length;
                                                        x++) ...[
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                // SizedBox(height: 10),
                                                                SizedBox(
                                                                  width:
                                                                      useMobileLayout
                                                                          ? 130
                                                                          : 180,
                                                                  height: 50,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50.0),
                                                                      ),
                                                                      backgroundColor: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          55,
                                                                          57,
                                                                          175), // foreground
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pushReplacementNamed(
                                                                          context,
                                                                          POS.routeName,
                                                                          arguments: {
                                                                            'subscription':
                                                                                subscriptions[x]
                                                                          });
                                                                    },
                                                                    child: Text(
                                                                      //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                                                      subscriptions[x]
                                                                              [
                                                                              'duration'] +
                                                                          " " +
                                                                          subscriptions[x]
                                                                              [
                                                                              'duration_unit'],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize: useMobileLayout
                                                                              ? 14
                                                                              : 25,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // color: Colors.white,
                                                                    // textColor: Colors.black,
                                                                    // splashColor: Colors.yellowAccent[800],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 50,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    subscriptions[x]
                                                                            [
                                                                            'name'] +
                                                                        " for P" +
                                                                        subscriptions[x]['price']
                                                                            .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          TextStyle(
                                                                        fontSize: useMobileLayout
                                                                            ? 12
                                                                            : 30,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ]
                                                  ]
                                                : <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              "NO CURRENT SUBSCRIPTION",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      useMobileLayout
                                                                          ? 14
                                                                          : 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            //        decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10),
                            //   color: Colors.white,
                            // ),
                            child: Card(
                              // elevation: 4,
                              color: Colors.white,
                              //margin: EdgeInsets.all(8),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              child: Container(
                                // height:  150,
                                width: double.infinity,
                                //width: useMobileLayout ? 600 : 700,

                                //height: useMobileLayout ? 90 : 150,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(10),
                                //   color: Colors.white,
                                // ),
                                // color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 15),
                                child: Container(
                                  height: 200.0,
                                  // color: Colors.blue[50],
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 15, horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.white,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 5),
                                  child: quickLinks!.isNotEmpty
                                      ? ListView(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          children: <Widget>[
                                              for (var x = 0;
                                                  x < quickLinks.length;
                                                  x++) ...[
                                                (Container(
                                                  alignment: Alignment.center,
                                                  child: Column(children: [
                                                    for (var y = 0;
                                                        y <
                                                            quickLinks[x]
                                                                .length;
                                                        y++) ...[
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("here");
                                                          UrlLauncher.launch(
                                                              'tel:+${quickLinks[x][y]['link']}');
                                                        },
                                                        child: Container(
                                                          width: 120.0,
                                                          height: 70.0,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    quickLinks[x]
                                                                            [y][
                                                                        'image_url']),
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                          // child: Text(quickLinks[x][y]['description']),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      )
                                                    ]
                                                  ]),
                                                )),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ]
                                            ])
                                      : Expanded(
                                          child: Center(
                                            child: Text(
                                              "NO CURRENT DATA",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      useMobileLayout ? 14 : 25,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        child: const Center(
                        child: CircularProgressIndicator(),
                      )),
              ),
              isLoading
                  ? Card(
                      elevation: 4,
                      color: Colors.white.withOpacity(0.8),
                      //margin: EdgeInsets.all(8),
                      shape: const RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(10),
                          ),
                      child: SizedBox(
                        // height:  150,
                        width: double.infinity,
                        //width: useMobileLayout ? 600 : 700,

                        //height: useMobileLayout ? 90 : 150,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        //   color: Colors.white,
                        // ),
                        // padding:
                        //     EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                        child: Column(children: [
                          // Container(
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     // color: Colors.grey[200],

                          //     image: DecorationImage(
                          //       image:
                          //           const AssetImage('assets/images/move_mandaue.jpg'),
                          //       fit: BoxFit.cover,
                          //       // colorFilter: ColorFilter.mode(
                          //       //   Colors.black.withOpacity(0.2),
                          //       //   BlendMode.dstATop,
                          //       // ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width: double.infinity,
                            child: ads.isNotEmpty
                                ? CarouselSlider(
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        // enlargeCenterPage: true,
                                        viewportFraction: 1.0,
                                        height: 100,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.height,
                                        scrollPhysics:
                                            const NeverScrollableScrollPhysics()),
                                    items: ads.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // margin: EdgeInsets.symmetric(horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      i['image_url']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                            // child: Text(i['description']),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        "NO CURRENT ADS",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: useMobileLayout ? 14 : 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   child: CarouselSlider(
                          //     options: CarouselOptions(
                          //       autoPlay: true,
                          //       aspectRatio: 2.0,
                          //       // enlargeCenterPage: true,
                          //       viewportFraction: 1.0,
                          //       height: 100,
                          //       enlargeStrategy:
                          //           CenterPageEnlargeStrategy.height,
                          //     ),
                          //     items: imgLists.map((i) {
                          //       return Builder(
                          //         builder: (BuildContext context) {
                          //           return Container(
                          //             width: MediaQuery.of(context).size.width,
                          //             // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          //             decoration: BoxDecoration(
                          //               image: DecorationImage(
                          //                   image: AssetImage(i['image']),
                          //                   fit: BoxFit.fitWidth),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     }).toList(),
                          //   ),
                          // )
                        ]),
                      ),
                    )
                  : Container()
            ],
          ),
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
      onPressed: onPressed(),
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
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails(this.title, this.value, {super.key});

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
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
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
