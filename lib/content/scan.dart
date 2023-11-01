import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:konek_app/content/uploadpic.dart';
import 'package:scan/scan.dart';

class ScanQR extends StatefulWidget {
  static const routeName = '/scan';
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  ScanController controller = ScanController();
  String qrcode = 'Unknown';

    @override
  void dispose() {
    controller.pause();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // custom wrap size
      height: 250,
      child: ScanView(
        controller: controller,
// custom scan area, if set to 1.0, will scan full area
        scanAreaScale: .7,
        scanLineColor: Colors.green.shade400,
        onCapture: (data) {
          print("here" + data.toString());
          Navigator.pop(context, data);
        },
      ),
    );
  }
}
