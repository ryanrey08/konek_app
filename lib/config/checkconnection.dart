// Packages and Libraries
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './Config.dart' as config;

/* <======= END ========> */

class GlobalToast with ChangeNotifier {
  static Map source = {ConnectivityResult.none: false};
  static MyConnectivity connectivity = MyConnectivity.instance;
  static String? message;

  static SharedPreferences? sharedPreferences;

  BuildContext? context;

  static checkConnection(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    GlobalToast.connectivity.initialise();
    GlobalToast.connectivity.myStream.listen((event) {
      GlobalToast.source = event;
      //GlobalToast.showToast();
      GlobalToast.showToast(flutterLocalNotificationsPlugin);

      // function get recent updates
    });
  }

// static Future<void> _showErrorDialog(BuildContext context) {
//   String message;
//   switch (source.keys.toList()[0]) {
//       case ConnectivityResult.none:
//         message = "Offline";
//         break;
//       case ConnectivityResult.mobile:
//         message = "Mobile: Online";
//         break;
//       case ConnectivityResult.wifi:
//         message = "WiFi: Online";
//     }
//     if(message == "Offline"){
//       return showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//             title: Text('An Error Occurred!'),
//             content: Text(message),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               )
//             ],
//           ),
//     );

//     }
// }

  static showToast(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    switch (source.keys.toList()[0]) {
      case ConnectivityResult.none:
        message = "Offline";
        break;
      case ConnectivityResult.mobile:
        message = "Mobile: Online";
        break;
      case ConnectivityResult.wifi:
        message = "WiFi: Online";
    }

    if (message == "Offline") {
      // Fluttertoast.showToast(
      //   msg: 'Connection Error',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Color(0xff404747),
      //   textColor: Colors.white,
      //   fontSize: 13.0,
      // );
    } else if (message == "Mobile: Online") {
      // Fluttertoast.showToast(
      //   msg: 'Connection Established',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Color(0xff404747),
      //   textColor: Colors.white,
      //   fontSize: 13.0,
      // );

      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences!.containsKey('userData')) {
        // _showNotification(flutterLocalNotificationsPlugin);
      }

      // _showNotification(flutterLocalNotificationsPlugin);
    } else if (message == "WiFi: Online") {
      // Fluttertoast.showToast(
      //   msg: 'Connection Established',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Color(0xff404747),
      //   textColor: Colors.white,
      //   fontSize: 13.0,
      // );

      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences!.containsKey('userData')) {
        // _showNotification(flutterLocalNotificationsPlugin);
      }
    }

    //  return scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(message),
    // ));
  }

  static Future<bool> hasConnection() async {
    if (message == 'Offline') {
      return false;
    } else {
      return true;
    }
  }

  
  // static Map get source{
  //   return {..._source};
  // 

  // @override
  // void initState() {
  //   super.initState();
  //   _connectivity.initialise();
  //   _connectivity.myStream.listen((source) {
  //     setState(() => _source = source);
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   String string;
  //   switch (_source.keys.toList()[0]) {
  //     case ConnectivityResult.none:
  //       string = "Offline";
  //       break;
  //     case ConnectivityResult.mobile:
  //       string = "Mobile: Online";
  //       break;
  //     case ConnectivityResult.wifi:
  //       string = "WiFi: Online";
  //   }

  //   return Scaffold(
  //     appBar: AppBar(title: Text("Internet")),
  //     body: Center(child: Text("$string", style: TextStyle(fontSize: 36))),
  //   );
  // }

  // @override
  // void dispose() {
  //   _connectivity.disposeStream();
  //   super.dispose();
  // }
}

class MyConnectivity with ChangeNotifier {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
    notifyListeners();
  }

  void disposeStream() => controller.close();
}
