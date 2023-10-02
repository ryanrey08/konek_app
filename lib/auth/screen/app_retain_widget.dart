import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppRetainWidget extends StatefulWidget {
  AppRetainWidget({key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _AppRetainWidgetState createState() => _AppRetainWidgetState();
}

class _AppRetainWidgetState extends State<AppRetainWidget> {
  final _channel = MethodChannel('com.example/app_retain');

//   @override
// void initState() {
//   super.initState();
//   print('initState');
//    _channel.setMethodCallHandler(platformCallHandler);
// }

//   Future<dynamic> platformCallHandler(MethodCall call) async {
//   if (call.method == "destroy"){
//     print("destroy");
//     dispose();
//   }
// }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return true;
          } else {
            await _channel.invokeMethod('sendToBackground');
            return false;
          }
        } else {
          return true;
        }
      },
      child: widget.child,
    );
  }
}
