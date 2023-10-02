import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Sample",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: useMobileLayout ? 16 : 18,
            ),
          ),
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  // await Provider.of<Auth>(context, listen: false).logout();
                  // Navigator.of(context).pushReplacementNamed(Login.routeName);
                },
                child: Icon(
                  Icons.notifications,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Container(child: Text('dashboard ni ryan')),
    ));
  }
}
