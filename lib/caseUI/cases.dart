import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/UserLogin/logIn.dart';
import 'package:ihssan_app/admin/createCase.dart';
import 'package:ihssan_app/services/loading.dart';

class Cases extends StatefulWidget {
  const Cases({Key key}) : super(key: key);

  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  List cases = [];

  var refreashKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
    }
    _fetchCases();
    super.initState();
  }

  Future<Null> _fetchCases() async {
    FirebaseFirestore.instance.collection('cases').get().then((querySnapshot) {
      cases.clear();
      querySnapshot.docs.forEach((element) {
        cases.add(element.data());
        // print(element.data());
      });
      // print(cases);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                leading: FlatButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                title: Text(
                  'cases ',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.orangeAccent,
                actions: [
                  FlatButton(
                      onPressed: () {
                        auth.signOut();
                        setState(() => loading = true);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Icon(Icons.logout)),
                ]),
            body: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 50.0, // soften the shadow
                    spreadRadius: 6.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      10.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              // Use ListView.builder
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Card(
                  color: Colors.black54,
                  margin: EdgeInsets.symmetric(vertical: 19.0, horizontal: 0.0),
                  child: ListTile(
                    leading: Text(
                      '${user.email}',
                      //  NomUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    subtitle: Text(
                      'WELCOME TO IHSSAN APP WHERE YOU CAN HELP AND GET HELP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    key: refreashKey,
                    onRefresh: _fetchCases,
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ListView.builder(
                            // the number of items in the list
                            itemCount: cases.length,
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                   backgroundColor: Colors.white,

                                      child: cases[index]["image"] != null
                                          ? ClipOval(
                                              child: Image.network(
                                              cases[index]["image"],
                                              fit: BoxFit.cover,
                                                width: 100.0,
                                            ),
                                      )
                                          : Icon(Icons.person)),
                                  title: Text(
                                    cases[index]['name'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    cases[index]['description'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  trailing: Icon(Icons.more_vert,
                                      color: Colors.deepPurple),
                                  dense: true,
                                  selected: true,
                                  onTap: () {
                                    /* react to the tile being tapped */
                                  },
                                ),
                              );
                            })),
                  ),
                )
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // _fetchCases();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCustomForm()));
              },
              child: Icon(Icons.add),
            ),
          );
  }
}
