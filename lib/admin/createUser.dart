
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/UsersDatabase.dart';
import 'package:ihssan_app/admin/users.dart';

import '../home.dart';
class CreateUser extends StatefulWidget {
  @override
  CreateUserState createState() {
    return CreateUserState();
  }
}

class CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  String name, email, role, password;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Create User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
          decoration: InputDecoration(
              hintText: 'name',
              border: UnderlineInputBorder(),
              labelText: 'Enter user name'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  the user name';
                  }
                  name = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'email',
                    border: UnderlineInputBorder(),
                    labelText: 'Enter user name'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  user email';
                  }
                  email = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'role',
                    border: UnderlineInputBorder(),
                    labelText: 'Enter user role'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  the user name';
                  }
                  role= value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'password',
                    border: UnderlineInputBorder(),
                    labelText: 'Enter user password'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  the user password';
                  }
                  password= value;
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState.validate()) {
                    createUser();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
              // Add TextFormFields and ElevatedButton here.
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    EasyLoading.show(status: "Loading...");
    try {
      final User user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      if (user != null) {
        // await UsersDatabase(userUid: user.uid).adduser(name: name, role: role);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
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

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red,));
    }
  }
}