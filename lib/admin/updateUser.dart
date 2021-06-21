
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ihssan_app/UsersDatabase.dart';
import 'package:ihssan_app/admin/users.dart';

import '../home.dart';
class UpdateUser extends StatefulWidget {
  final Map<String, dynamic> user;

  const UpdateUser({Key key, @required this.user}) : super(key: key);

  @override
  UpdateUserState createState() {
    return UpdateUserState();
  }
}


class UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  String name, email, password;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    name = auth.currentUser.displayName;
    email = auth.currentUser.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: name,
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
                  initialValue: email,
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
                      hintText: 'password',
                      border: UnderlineInputBorder(),
                      labelText: 'Enter user password'),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // return 'Please enter  the user password';
                    }
                    password= value;
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) {
                      updateProfile();
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Submit'),
                ),
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    EasyLoading.show(status: "Loading...");
    try {
      final User user = auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: name);
        await user.updateEmail(email);
        // await user.updatePassword(password);
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