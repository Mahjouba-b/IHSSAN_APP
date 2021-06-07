import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/UserLogin/signUp.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'package:ihssan_app/services/loading.dart';

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
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.orangeAccent,
                elevation: 0.0,
                title: Text(' Sign In',style: TextStyle(color: Colors.black)  ),
                actions: <Widget>[
                  // TODO: fix this
                  FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text('Register'))
                ]),
            backgroundColor: Colors.purple[900],
            body: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20.0),
                    Image(
                      image: AssetImage('images/ihssan_logo.PNG'),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _emailController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintText: 'email',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _passwordController,
                          autocorrect: true,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.black,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          )),
                    ),
                    FlatButton(
                      child: Text('Log in'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.orangeAccent,
                      splashColor: Colors.blueGrey,
                      textColor: Colors.black,
                      onPressed: () {
                        loginIn();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> loginIn() async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() => loading = true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Cases()));
      print(user);
    } else {
      // TODO: fix this
      loading = false;
      _showToast(context);
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
