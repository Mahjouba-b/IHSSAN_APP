import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/UserLogin/ResetPassword.dart';
import 'package:ihssan_app/UserLogin/signUp.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/home.dart';

class LogIn extends StatefulWidget {
  //You have to create a list with the type of login's that you are going to import into your application

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LogIn> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  // title: Text(' Sign In',style: TextStyle(color: Colors.orangeAccent)  ),
                  actions: <Widget>[

                    FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Text('Register'),textColor:Colors.orangeAccent,)
                  ]),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: _passwordController,
                            autocorrect: true,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
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
                            child: Text('Log in')),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.deepPurple,
                        splashColor: Colors.blueGrey,
                        textColor: Colors.white,
                        onPressed: () {
                          loginIn();
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ResetPassword()));
                          },
                          child: Text("Forget Password")
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> loginIn() async {
    EasyLoading.show(status: "Loading...");
    try{
      final User user = (await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() => loading = true);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        print(user);
      } else {
        // TODO: fix this
        loading = false;
        _showToast(context);
      }
      EasyLoading.dismiss();
    } catch(e){
      EasyLoading.dismiss();
    String errorMessage;
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red,));
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
