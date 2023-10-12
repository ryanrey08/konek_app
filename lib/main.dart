import 'package:flutter/material.dart';
import 'package:konek_app/profile/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:konek_app/auth/screens/login.dart';
import 'package:konek_app/auth/screens/register.dart';

import 'auth/screens/app_retain_widget.dart';
import 'auth/providers/auth.dart';
import './content/dashboard.dart';
import 'auth/screens/splashscreen.dart';
import 'content/pos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyApp> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyApp> {

  final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
      providers: [
                ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: AppRetainWidget(
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            darkTheme: ThemeData.dark(),
            navigatorKey: navigatorKey,
            //home: MySplashScreen(Login()),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? Dashboard()
                // ? MySplashScreen(CovidDashboard())
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState == ConnectionState.waiting ? CircularProgressIndicator() : MySplashScreen(Login()),
                  ),
            routes: {
              Dashboard.routeName: (context) => Dashboard(),
              Login.routeName: (context) => Login(),
              // ignore: equal_keys_in_map
              AccountRegister.routeName: (context) => AccountRegister(),
              MyProfile.routeName: (context) => MyProfile(),
              POS.routeName: (context) => POS(),
            },
          ),
        ),
      ),
    );
  }
}