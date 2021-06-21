import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/UsersDatabase.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'package:ihssan_app/home.dart';
import 'package:ihssan_app/services/loading.dart';

import 'logIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white60,
                elevation: 0.0,
                title: Text("Register ",
                    style: TextStyle(color: Colors.orangeAccent)),
                actions: <Widget>[
                  // TODO: fix this
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Text('Sign In'),
                    textColor: Colors.orangeAccent,
                  )
                ]),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    Image(
                      image: AssetImage('images/ihssan_logo.PNG'),
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      style: TextStyle(color: Colors.deepPurple),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'name',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        fillColor: Colors.white30,
                        filled: true,
                        hintText: 'Enter  name',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                      ),
                      controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "* Required";
                        } else if (value.length < 3) {
                          return "name should be atleast 3 characters";
                        } else if (value.length > 15) {
                          return "name should not be greater than 15 characters";
                        } else
                          return null;
                      },
                    ),
                    /* TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.always, decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'phone',
                      hintText: 'Enter  phone'),

                    validator: (value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else if (value.length < 8) {
                        return "PHONE should be atleast 8 numbers";
                      } else if (value.length > 13) {
                        return "Password should not be greater than 13 characters";
                      } else
                        return null;
                    },
                  ),*/
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _emailController,

                      style: TextStyle(color: Colors.deepPurple),
                      decoration: InputDecoration(
                        fillColor: Colors.white30,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'email',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        hintText: 'Enter  email',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                      ),
                      /*   validator: (value) {
                      if (value.isEmpty) {
                        return "* Required";
                      }
                        return null;
                    },*/
                      validator: (value) => EmailValidator.validate(value)
                          ? null
                          : "*required -Please enter a valid email ",
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      controller: _passwordController,

                      obscureText: true,
                      style: TextStyle(color: Colors.deepPurple),
                      decoration: InputDecoration(
                        fillColor: Colors.white30,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.deepPurple),
                        hintText: 'Enter  password',
                        hintStyle: TextStyle(color: Colors.deepPurple),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "* Required";
                        } else if (value.length < 6) {
                          return "Password should be atleast 6 characters";
                        } else if (value.length > 15) {
                          return "Password should not be greater than 15 characters";
                        } else
                          return null;
                      },
                    ),
                    FlatButton(
                        child: Text('Register'),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.deepPurple,
                        splashColor: Colors.yellow,
                        textColor: Colors.white,
                        onPressed: () {
                          _register();
                        })
                  ],
                ),
              ),
            )),
          );
  }

  Future<void> _register() async {
    EasyLoading.show(status: "Loading...");
    try {
      final User user = (await auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        user.updateProfile(displayName: _nameController.text);
        await UsersDatabase(userUid: user.uid)
            .adduser(name: _nameController.text);
        setState(() => loading = true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        print(user);
      } else {
        loading = false;
        print('error');
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      String errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "The email is already in use by a different account.";
          break;
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }
}
