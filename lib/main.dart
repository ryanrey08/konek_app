import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konek_app/config/checkconnection.dart';
import 'package:konek_app/config/notification.dart';
import 'package:konek_app/content/notification.dart';
import 'package:konek_app/content/provider/content.dart';
import 'package:konek_app/content/provider/pos.dart';
import 'package:konek_app/content/provider/voucher.dart';
import 'package:konek_app/content/scan.dart';
import 'package:konek_app/content/uploadpic.dart';
import 'package:konek_app/profile/providers/profileprovider.dart';
import 'package:konek_app/profile/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:konek_app/auth/screens/login.dart';
import 'package:konek_app/auth/screens/register.dart';

import 'auth/screens/app_retain_widget.dart';
import 'auth/providers/auth.dart';
import './content/dashboard.dart';
import 'auth/screens/splashscreen.dart';
import 'content/pos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  // runApp(MyApp());
  GlobalToast.checkConnection();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        // ChangeNotifierProxyProvider<Auth, Voucher>(
        //   builder: (ctx, auth, userData) => Voucher(
        //     auth.token,
        //   ),
        // ),
        ChangeNotifierProxyProvider<Auth, Voucher>(
          //create: (context) => Voucher(''),
          update: (context, auth, userData) {
            // Pass the value from AuthProvider to UserProvider
            // userData?.updateUserData(authProvider?.isLoggedIn ?? false);
            // return userData!;
            return userData ?? Voucher(auth.token);
          },
          create: (BuildContext context) {
            // You can pass any required parameters to the create method
            // In this example, we pass a token from AuthProvider
            final Auth authProvider = Provider.of<Auth>(context, listen: false);
            final String token = authProvider.token;

            // Instantiate the UserProvider with the token
            return Voucher(token);
          },
          // create: (BuildContext context) {
          //   // This won't be used because we use the update function.
          //   throw UnimplementedError();
          // },
        ),
        ChangeNotifierProxyProvider<Auth, Content>(
          //create: (context) => Voucher(''),
          update: (context, auth, userData) {
            // Pass the value from AuthProvider to UserProvider
            // userData?.updateUserData(authProvider?.isLoggedIn ?? false);
            // return userData!;
            return userData ?? Content(auth.token);
          },
          create: (BuildContext context) {
            // You can pass any required parameters to the create method
            // In this example, we pass a token from AuthProvider
            final Auth authProvider = Provider.of<Auth>(context, listen: false);
            final String token = authProvider.token;

            // Instantiate the UserProvider with the token
            return Content(token);
          },
          // create: (BuildContext context) {
          //   // This won't be used because we use the update function.
          //   throw UnimplementedError();
          // },
        ),
        ChangeNotifierProxyProvider<Auth, POSProvider>(
          //create: (context) => Voucher(''),
          update: (context, auth, userData) {
            // Pass the value from AuthProvider to UserProvider
            // userData?.updateUserData(authProvider?.isLoggedIn ?? false);
            // return userData!;
            return userData ?? POSProvider(auth.token);
          },
          create: (BuildContext context) {
            // You can pass any required parameters to the create method
            // In this example, we pass a token from AuthProvider
            final Auth authProvider = Provider.of<Auth>(context, listen: false);
            final String token = authProvider.token;

            // Instantiate the UserProvider with the token
            return POSProvider(token);
          },
          // create: (BuildContext context) {
          //   // This won't be used because we use the update function.
          //   throw UnimplementedError();
          // },
        ),
        ChangeNotifierProxyProvider<Auth, ProfileProvider>(
          //create: (context) => Voucher(''),
          update: (context, auth, userData) {
            // Pass the value from AuthProvider to UserProvider
            // userData?.updateUserData(authProvider?.isLoggedIn ?? false);
            // return userData!;
            return userData ?? ProfileProvider(auth.token);
          },
          create: (BuildContext context) {
            // You can pass any required parameters to the create method
            // In this example, we pass a token from AuthProvider
            final Auth authProvider = Provider.of<Auth>(context, listen: false);
            final String token = authProvider.token;

            // Instantiate the UserProvider with the token
            return ProfileProvider(token);
          },
          // create: (BuildContext context) {
          //   // This won't be used because we use the update function.
          //   throw UnimplementedError();
          // },
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
                ? MySplashScreen(const Dashboard())
                // ? MySplashScreen(CovidDashboard())
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const CircularProgressIndicator()
                            : MySplashScreen(const Login()),
                  ),
            routes: {
              //Dashboard
              Dashboard.routeName: (context) => const Dashboard(),
              //Login
              Login.routeName: (context) => const Login(),
              // ignore: equal_keys_in_map
              //Registration
              AccountRegister.routeName: (context) => AccountRegister(),
              //Profile
              MyProfile.routeName: (context) => MyProfile(),
              //POS
              POS.routeName: (context) => const POS(),
              //QR Code
              ScanQR.routeName: (context) => const ScanQR(),
              //Voucher
              UploadPicture.routeName: (context) => const UploadPicture(),
              //Notification
              NotificationList.routeName: (context) => const NotificationList(),
            },
          ),
        ),
      ),
    );
  }
}
