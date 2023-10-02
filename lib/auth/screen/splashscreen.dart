import 'package:flutter/material.dart';
// import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class MySplashScreen extends StatefulWidget {
  final Widget _widget;

  @override
  _MyAppState createState() => new _MyAppState();

  MySplashScreen(this._widget);
}

class _MyAppState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    return SplashScreen(
      useMobileLayout: useMobileLayout,
      seconds: 5, //1
      navigateAfterSeconds: widget._widget,
    );
  }
}

class SplashScreen extends StatefulWidget {
  final int seconds;
  final dynamic navigateAfterSeconds;
  final bool useMobileLayout;

  SplashScreen({required this.seconds, this.navigateAfterSeconds, required this.useMobileLayout});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.seconds), () {
      if (widget.navigateAfterSeconds is String) {
        // It's fairly safe to assume this is using the in-built material
        // named route component
        Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
      } else if (widget.navigateAfterSeconds is Widget) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => widget.navigateAfterSeconds));
      } else {
        throw new ArgumentError('widget.navigateAfterSeconds must either be a String or Widget');
      }
    });
  }

  String state = 'Animation start';
  bool isRunning = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/eaggro-bg.jpg'),
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
            //   colors: [
            //    Colors.white, Colors.green[300]
            //   ],
            // ),
          ),
          // decoration: BoxDecoration(
          //                   gradient: LinearGradient(
          //                       begin: Alignment.topLeft,
          //                       end: Alignment.bottomRight,
          //                       colors: [Colors.blue[700], Colors.purple[300]])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   'WELCOME TO',
                      //   textAlign: TextAlign.center,
                      //   style: GoogleFonts.poppins(
                      //     textStyle: TextStyle(
                      //       fontSize: 30,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                      //  SizedBox(height: 10),
                      Image.asset(
                        'assets/images/eaggro-1.png',
                        width: widget.useMobileLayout ? 300 : 350,
                        height: widget.useMobileLayout ? 300 : 350,
                      ),
                      // Text(
                      //   "FARMER'S ASSISTANCE PROGRAM",
                      //   textAlign: TextAlign.center,
                      //   style: GoogleFonts.poppins(
                      //     textStyle: TextStyle(
                      //       fontSize: 20,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                     
                      
                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      // Text("splashscreen.dart")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
