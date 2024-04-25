import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/content/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/httpexception.dart';

import 'provider/voucher.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<String> data = [];
  bool isLoading = false;
  var voucherData;

    @override
  void initState() {
    super.initState();
    getVoucherData();
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
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 55, 57, 175),
      //   leading: Builder(builder: (BuildContext context) {
      //     return IconButton(
      //         icon: Icon(Icons.keyboard_arrow_left),
      //         onPressed: () {
      //           Navigator.pushReplacementNamed(context, Dashboard.routeName);
      //         } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
      //   }),
      //   automaticallyImplyLeading: false,
      //   title: Text('My Profile',
      //       style: GoogleFonts.poppins(
      //         fontSize: useMobileLayout ? 16 : 18,
      //       )),
      // ),
      body: isLoading ? RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: getVoucherData,
        child: ListView.builder(
          itemCount: voucherData.length,
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
