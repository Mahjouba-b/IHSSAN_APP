import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/home.dart';
import 'UserLogin/logIn.dart';
import 'global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyLocalization(
      child: MyApp(),
    supportedLocales: [
      Locale('en'),
      Locale('ar'),
      Locale('fr'),
    ],
    path: 'langs',
  )
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: CheckAuth(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isAuth = false;
  Widget child;
  @override
  void initState() {
    if (auth.currentUser != null) {
      isAuth = true;
      child = Home();
    } else {
      child = LogIn();
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
