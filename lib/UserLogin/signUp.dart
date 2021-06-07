import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'package:ihssan_app/services/loading.dart';

import 'logIn.dart';

class SignUp extends StatefulWidget {

  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading= false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold( backgroundColor: Colors.purple[900],
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
        title: Text("Register ",style: TextStyle(color: Colors.black) ),
          actions: <Widget>[
            // TODO: fix this
            FlatButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn())); },
                child: Text('Sign In'))
          ]
      ),
      body: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always, child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Image(
                  image: AssetImage('images/ihssan_logo.PNG'),
                ),
                SizedBox(height: 20.0),

                /*   TextFormField(
                  autovalidateMode: AutovalidateMode.always, decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'name',
                    hintText: 'Enter  name'),
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
                ),*/
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
                  controller : _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    labelText: 'email',
                    hintText: 'Enter  email'),
    /*   validator: (value) {
                    if (value.isEmpty) {
                      return "* Required";
                    }
                      return null;
                  },*/
                  validator: (value) => EmailValidator.validate(value) ? null : "*required -Please enter a valid email ",

                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller : _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.black,
                     border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter  password'),
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
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    color: Colors.orangeAccent,
    splashColor: Colors.purple,
    textColor: Colors.black,
    onPressed: ()
    {
      _register();

    }
    ) ],
            ),
          )
      ),);
  }
  Future<void> _register() async {
final User user = (await auth.createUserWithEmailAndPassword(
  email: _emailController.text,
  password: _passwordController.text,
)).user;
if(user != null){
  setState(() => loading = true);
  Navigator.push(context, MaterialPageRoute(builder: (context)=> Cases()));
  print(user);
} else {
  loading = false;
  print('error');
}
  }
}
