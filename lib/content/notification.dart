import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/content/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var voucherData;
  var notificationData;

    @override
  void initState() {
    super.initState();
    getVoucherData();
    getNotification();
  }

    Future<void> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('notificationData')) {
      notificationData = [];
    } else {
      final extracteduserData =
          json.decode(prefs.getString('notificationData')!) as Map<String, dynamic>;
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
    // setState(() {
    //   isLoading = true;
    // });

    try {
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      voucherData = await Provider.of<Voucher>(context, listen: false).getMyVoucher();

    } on HttpException catch (error) {
      print(error);
      showError(error.toString());
    } catch (error) {
      showError(error.toString());
    }
    setState(() {
      isLoading = true;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 57, 175),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Dashboard.routeName);
              } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
        }),
        automaticallyImplyLeading: false,
        title: Text('Notifications',
            style: GoogleFonts.poppins(
              fontSize: useMobileLayout ? 16 : 18,
            )),
      ),
      body: isLoading ? RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: getNotification,
        child: ListView.builder(
          itemCount: notificationData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(voucherData[index]['description']),
              subtitle: Text(voucherData[index]['claimed_date'] + " - " + (voucherData[index]['expire_date'])),
            );
          },
        ),
      ) : Container(),
    );
  }
}
