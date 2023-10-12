import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../content/dashboard.dart';

class POS extends StatefulWidget {
  static const routeName = '/pos';
  const POS({super.key});

  @override
  State<POS> createState() => _POSState();
}

class _POSState extends State<POS> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String paymentMethod = "GCASH";

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: Scaffold(
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
        title: Text('POS',
            style: GoogleFonts.poppins(
              fontSize: useMobileLayout ? 16 : 18,
            )),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4,
              color: Colors.white.withOpacity(0.8),
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                // height:  150,
                width: double.infinity,

                height: useMobileLayout ? 110 : 170,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 55, 57, 175)),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
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
                          Text(
                            '1 Day',
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
                              SizedBox(height: 10),
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
                              Text(
                                '1 Day Unlimited All Surf Data for P50',
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
              margin: EdgeInsets.all(8),
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
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // SizedBox(height: 10),
                                Radio(
                                    value: "UNION BANK",
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentMethod = value.toString();
                                      });
                                    }),
                                SizedBox(
                                  // width: useMobileLayout ? 130 : 180,
                                  // height: 50,
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      child: const Image(
                                        // image: NetworkImage(
                                        //     'assets/images/novulutions.png'),
                                        image: AssetImage(
                                            'assets/images/unionbank.png'),
                                      )),
                                ),
                                Radio(
                                    value: "GCASH",
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentMethod = value.toString();
                                      });
                                    }),
                                SizedBox(
                                  child: Container(
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
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 55, 57, 175), // background
            onPrimary: Colors.white, // foreground
            //                color: Colors.yellow,
            // textColor: Colors.black,
            // splashColor: Colors.yellowAccent[800],
          ),
          // color: Colors.green,
          // textColor: Colors.black,
          // splashColor: Colors.yellowAccent[800],
        ),
      ),
    ));
  }
}
