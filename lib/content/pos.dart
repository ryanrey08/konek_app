import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/config/httpexception.dart';
import 'package:konek_app/content/provider/content.dart';
import 'package:konek_app/content/provider/pos.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../content/dashboard.dart';

class POS extends StatefulWidget {
  static const routeName = '/pos';
  const POS({super.key});

  @override
  State<POS> createState() => _POSState();
}

class _POSState extends State<POS> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var subscription = {};
  bool isLoading = true;
  bool isLoadingRequest = false;
  var requestPaymentDataUrl = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final Map<String, dynamic> subsData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      subscription = subsData['subscription'];
      isLoading = false;
    });
    print(subscription);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _GoPrevPage(context);
    // });
    getProfile();
  }

  _GoPrevPage(BuildContext context) {
    if (requestPaymentDataUrl != '') {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (Route<dynamic> route) => false,
      );
    }
  }

  navigateToHomePage() {
    if (requestPaymentDataUrl != '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String paymentMethod = "GCASH";
  String? email;
  String? phone;

  getProfile() async {
    SharedPreferences sharedPreferences;

    sharedPreferences = await SharedPreferences.getInstance();

    final extractedUserData =
        json.decode(sharedPreferences.getString('userData')!)
            as Map<String, dynamic>;
    final data = extractedUserData['data']['user'] as Map<String, dynamic>;

    setState(() {
      email = data['email'] ?? '';
      phone = data['mobile_no'] ?? '';
    });
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

  sendPaymentRequest() async {
    setState(() {
      isLoadingRequest = true;
    });
    try {
      var subscriptionsData =
          await Provider.of<POSProvider>(context, listen: false)
              .sendPaymentRequest(
                  email, phone, subscription['price'], subscription['id']);

      setState(() {
        requestPaymentDataUrl = subscriptionsData['url'];
      });
      // await UrlLauncher.launch("http://10.44.77.253:2060/ext_login?username=3MFREE&password=3MFREE&next_url=$requestPaymentDataUrl");
      await UrlLauncher.launch(requestPaymentDataUrl);
      var vouchData;

        try {
          //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
          vouchData = await Provider.of<POSProvider>(context, listen: false)
              .getMyPaymentStatus();
           SharedPreferences prefs = await SharedPreferences.getInstance();
           if(vouchData['status'] == 'complete'){
            prefs.setString('swakUrl', vouchData['url']);
           }
        } on HttpException catch (error) {
          print(error);
          showError(error.toString());
        } catch (error) {
          showError(error.toString());
        }

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (Route<dynamic> route) => false,
        );
        // Navigator.pushReplacementNamed(context, Dashboard.routeName,
        //     arguments: vouchData['url']);
      });
    } on HttpException catch (error) {
      showError(error.toString());
    } catch (error) {
      showError('something went wrong');
    }
    setState(() {
      // subscriptions = subscriptionsData;
      isLoadingRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: SafeArea(
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
          title: Text('POS',
              style: GoogleFonts.poppins(
                  fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Card(
                elevation: 4,
                color: Colors.white.withOpacity(0.8),
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  // height:  150,
                  width: double.infinity,

                  height: useMobileLayout ? 110 : 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 55, 57, 175)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: useMobileLayout ? 14 : 25,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            isLoading
                                ? const Text('')
                                : Text(
                                    "${subscription['duration']} ${subscription['duration_unit']}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: useMobileLayout ? 18 : 40,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            Text(
                              '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: useMobileLayout ? 18 : 40,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          // Icon(
                          //   Icons.wifi,
                          //   size: 60,
                          //   color: Colors.greenAccent,
                          // ),
                          Expanded(
                            child: Container(
                              child: Row(children: [
                                const SizedBox(height: 10),
                                Text(
                                  '',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: useMobileLayout ? 14 : 25,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                isLoading
                                    ? const Text('')
                                    : Text(
                                        "${subscription['name']} for P ${subscription['price']}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: useMobileLayout ? 12 : 35,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                Text(
                                  '',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: useMobileLayout ? 18 : 40,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                color: Colors.white.withOpacity(0.8),
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  // height:  150,
                  width: double.infinity,

                  //height: useMobileLayout ? 90 : 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // SizedBox(height: 10),
                                  // Radio(
                                  //     value: "UNION BANK",
                                  //     groupValue: paymentMethod,
                                  //     onChanged: (value) {
                                  //       setState(() {
                                  //         paymentMethod = value.toString();
                                  //         print(paymentMethod);
                                  //       });
                                  //     }),
                                  // SizedBox(
                                  //   // width: useMobileLayout ? 130 : 180,
                                  //   // height: 50,
                                  //   child: Container(
                                  //       width: 100,
                                  //       height: 100,
                                  //       child: const Image(
                                  //         // image: NetworkImage(
                                  //         //     'assets/images/novulutions.png'),
                                  //         image: AssetImage(
                                  //             'assets/images/unionbank.png'),
                                  //       )),
                                  // ),
                                  Radio(
                                      value: "GCASH",
                                      groupValue: paymentMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentMethod = value.toString();
                                          print(paymentMethod);
                                        });
                                      }),
                                  SizedBox(
                                    child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: const Image(
                                          // image: NetworkImag
                                          // e(
                                          //     'assets/images/novulutions.png'),
                                          image: AssetImage(
                                              'assets/images/gcash.png'),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          height: 50,
          width: double.infinity,
          child: isLoadingRequest
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: isLoadingRequest
                      ? null
                      : () {
                          sendPaymentRequest();
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Color.fromARGB(255, 55, 57, 175), // foreground
                    //                color: Colors.yellow,
                    // textColor: Colors.black,
                    // splashColor: Colors.yellowAccent[800],
                  ),
                  child: Text(
                    "CHECKOUT",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // color: Colors.green,
                  // textColor: Colors.black,
                  // splashColor: Colors.yellowAccent[800],
                ),
        ),
      )),
    );
  }
}
