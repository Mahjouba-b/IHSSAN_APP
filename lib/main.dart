import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UserLogin/logIn.dart';
import 'caseUI/cases.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      child: MaterialApp(
        home: CheckAuth(),
      ),
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
      child = Cases();
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
