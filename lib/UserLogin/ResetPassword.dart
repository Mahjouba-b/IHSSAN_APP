import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/UserLogin/logIn.dart';
import 'package:ihssan_app/UserLogin/signUp.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/home.dart';

class ResetPassword extends StatefulWidget {
  //You have to create a list with the type of ResetPassword's that you are going to import into your application

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ResetPassword> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20.0),
                Image(
                  image: AssetImage('images/ihssan_logo.PNG'),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _emailController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'email',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                          BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      )),
                ),
                FlatButton(
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Send Reset Link')),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.deepPurple,
                  splashColor: Colors.blueGrey,
                  textColor: Colors.white,
                  onPressed: () {
                    ResetPassword();
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Text("Login")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ResetPassword() async {
    EasyLoading.show(status: "Loading...");
    try{
      await auth.sendPasswordResetEmail(
        email: _emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check your email"), backgroundColor: Colors.red,));
      EasyLoading.dismiss();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LogIn()));
    } catch(e){
      EasyLoading.dismiss();
      String errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e), backgroundColor: Colors.red,));
    }
  }
}

void _showToast(BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('NON FOUND USER'),
      action:
      SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
