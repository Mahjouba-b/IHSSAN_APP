import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ihssan_app/UsersDatabase.dart';
import 'package:ihssan_app/admin/createUser.dart';
import 'package:ihssan_app/admin/updateUser.dart';

class Users extends StatefulWidget {
  const Users({Key key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool loading = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  List users = [];

  var refreashKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
    }
    _fetchUsers();
    super.initState();
  }

  Future<Null> _fetchUsers() async {
    EasyLoading.show(status: "Loading");
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      users.clear();
      querySnapshot.docs.forEach((element) {
        var item = {
          "id": element.id,
          "name": element.data()["name"],
          "role": element.data()["role"],
        };
        users.add(item);
        // print(element.data());
      });
      setState(() {
        loading = false;
      });
      EasyLoading.dismiss();
      // print(cases);
    });
  }

  void _changeRole(Map<String, dynamic> user, String role) async {
    showDialog(context: context,builder: (BuildContext context) {
      return Platform.isAndroid ? new AlertDialog(
        title: new Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                EasyLoading.show(status: "Loading...");
                await UsersDatabase(userUid: user["id"]).updateUser(role: role);
                EasyLoading.dismiss();
                _fetchUsers();

              },
              child: Text("Yes")
          ),
        ],
      )
          :
      CupertinoAlertDialog(
        title: new Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                EasyLoading.show(status: "Loading...");
                await UsersDatabase(userUid: user["id"]).updateUser(role: role);
                EasyLoading.dismiss();
                _fetchUsers();

              },
              child: Text("Yes")
          ),
        ],
      );
    }
    );

  }

  void _roleDialog(Map<String, dynamic> user) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text("Admin"),
                  subtitle: Text(""),
                  onTap: () {
                    Navigator.pop(context);
                    _changeRole(user, "Admin");
                  },
                ),
                ListTile(
                  title: Text("Manager"),
                  subtitle: Text(""),
                  onTap: () {
                    Navigator.pop(context);
                    _changeRole(user, "Manager");
                  },
                ),
                ListTile(
                  title: Text("User"),
                  subtitle: Text(""),
                  onTap: () {
                    Navigator.pop(context);
                    _changeRole(user, "User");
                  },
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: RefreshIndicator(
              key: refreashKey,
              onRefresh: _fetchUsers,
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: users.isEmpty ?
                  Center(
                    child: Text("No user found!"),
                  )
                  :
                  ListView.builder(
                    // the number of items in the list
                      itemCount: loading ? 0 : users.length,
                      shrinkWrap: true,
                      // display each item of the product list
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10.0,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: new Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: new Container(
                              color: Colors.white,
                              child: new ListTile(
                                title: Text(
                                  "${users[index]['name']}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(
                                  "${users[index]['role']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              new IconSlideAction(
                                caption: 'Change Role',
                                color: users[index]['role'] == "Admin" ? Colors.orange : Colors.red,
                                icon: Icons.edit,
                                onTap: () { _roleDialog(users[index]);},
                              ),
                            ],
                          )
                        );
                      })),
            ),
          )
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.orange,
      //   onPressed: () {
      //     // _fetchCases();
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => CreateUser()));
      //   },
      //   child: Icon(Icons.add) ,
      // ),
    );
  }
}
