import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/content/dashboard.dart';
import 'package:konek_app/content/provider/pos.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../config/httpexception.dart';

import 'provider/voucher.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const routeName = '/notification';

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<String> data = [];
  bool isLoading = false;
  var voucherData = [];
  var notificationData;

  @override
  void initState() {
    super.initState();
    getVoucherData();
    // getNotification();
  }

  Future<void> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('notificationData')) {
      notificationData = [];
    } else {
      final extracteduserData = json
          .decode(prefs.getString('notificationData')!) as Map<String, dynamic>;
      print(extracteduserData);
      setState(() {
        notificationData = extracteduserData;
      });
    }

    setState(() {
      isLoading = true;
    });
  }

  Future<void> getVoucherData() async {
    var errorMessage;
    voucherData = [];
    // setState(() {
    //   isLoading = true;
    // });

    try {
      setState(() {
        isLoading = false;
      });
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var voucher = await Provider.of<POSProvider>(context, listen: false)
          .getAllPaymentStatus();
      print(voucher);
      setState(() {
         voucher['data'].forEach((item) {
          if(item['payment_status'] == 'completed'){
            voucherData.add(item);
          }
        });
        print(voucherData);
        isLoading = true;
      });
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

    getTimeText(time){
      var nowDate = DateTime.now();
     var toDate = nowDate.add(Duration(days: 1));
    // int interval = toDate.difference(nowDate).inSeconds;
    return DateFormat("yyyy-MM-dd hh:mm").format(DateTime.now()).toString() + " - " + DateFormat("yyyy-MM-dd hh:mm").format(toDate).toString();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 55, 57, 175),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon:
                    const Icon(Icons.keyboard_arrow_left, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Dashboard.routeName);
                } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
          }),
          automaticallyImplyLeading: false,
          title: Text('Notifications',
              style: GoogleFonts.poppins(
                  fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
        ),
        body: isLoading
            ? RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: Colors.blue,
                strokeWidth: 4.0,
                onRefresh: getVoucherData,
                child: voucherData.length > 0
                    ? ListView.builder(
                        itemCount: voucherData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Your ' + 
                                  voucherData[index]['subscription']
                                          ['duration'] +
                                      " " +
                                      voucherData[index]['subscription']
                                          ['duration_unit'] +
                                      "/s Unlimited Data has been expired",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                // subtitle: Text(voucherData[index]['created_at'] + " - " + (voucherData[index]['expire_date'])),
                                subtitle: Text(
                                  getTimeText(voucherData[index]['payment_request_at']),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(), //
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Container(
                        child: Text(
                          'No Record Found',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )),
              )
            : Container(child: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
