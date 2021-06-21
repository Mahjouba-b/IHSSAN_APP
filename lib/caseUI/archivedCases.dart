import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ihssan_app/UserLogin/logIn.dart';
import 'package:ihssan_app/admin/createCase.dart';
import 'package:ihssan_app/admin/showCase.dart';
import 'package:ihssan_app/admin/updateCase.dart';
import 'package:ihssan_app/database.dart';
import 'package:ihssan_app/global.dart' as global;


class Cases extends StatefulWidget {
  const Cases({Key key}) : super(key: key);

  @override
  _CasesState createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  bool loading = true;
  bool isAdmin = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  List cases = [];

  var refreashKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
    }
    _userRole();
    _fetchCases();
    super.initState();
  }

  void _userRole() async {
    await FirebaseFirestore.instance.collection('users').doc(auth.currentUser.uid)
        .get().then((querySnapshot) =>{
      if(querySnapshot.data()["role"] == "Admin"){
        global.isAdmin = true,
        setState(() => {
          isAdmin = true
        })
      } else {
        global.isAdmin = false,
        setState(() => {
          isAdmin = false
        })
      },
    });
  }

  Future<Null> _fetchCases() async {
    EasyLoading.show(status: "Loading");
    FirebaseFirestore.instance.collection('cases').get().then((querySnapshot) {
      cases.clear();
      querySnapshot.docs.forEach((element) {
        var item = {
          "id": element.id,
          "name": element.data()["name"],
          "description": element.data()["description"],
          "state": element.data()["state"],
          "tel": element.data()["tel"],
          "image": element.data()["image"],
          "status": element.data()["status"] != null ? element.data()["status"] : "New",
        };
        if(item["status"] == "New"){
          cases.add(item);
        }
        // print(element.data()["name"]);
      });
      setState(() {
        loading = false;
      });
      EasyLoading.dismiss();
      // print(cases);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
            // appBar: AppBar(
            //     leading: FlatButton(
            //       onPressed: () {},
            //       child: Icon(
            //         Icons.person,
            //         color: Colors.white,
            //         size: 50.0,
            //       ),
            //     ),
            //     title: Text(
            //       'cases ',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     backgroundColor: Colors.orangeAccent,
            //     actions: [
            //       FlatButton(
            //           onPressed: () {
            //             auth.signOut();
            //             setState(() => loading = true);
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) => LogIn()));
            //           },
            //           child: Icon(Icons.logout)),
            //     ]),
            body: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 60.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      50.0, // Move to bottom 10 Vertically
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
                            itemCount: loading ? 0 : cases.length,
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
                                child:new Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: new Container(
                                    color: Colors.white,
                                    child: new ListTile(
                                      leading: CircleAvatar(
                                          backgroundColor: Colors.white,

                                          child: cases[index]["image"] != null
                                              ? ClipOval(
                                            child: Image.network(
                                              cases[index]["image"],
                                              fit: BoxFit.cover,
                                              width: 100.0,
                                              height: 100.0,
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
                                      onTap:() {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => showCase(item: cases[index])));

                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    isAdmin ? new IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.blue,
                                      icon: Icons.edit,
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => updateCase(item: cases[index])));

                                      },
                                    ) : SizedBox(),
                                  ],
                                  secondaryActions: <Widget>[
                                    isAdmin ?
                                    new IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () { deleteCase(cases[index]);},
                                    )
                                   : SizedBox(),
                                    isAdmin ?
                                    new IconSlideAction(
                                      caption: 'Archive',
                                      color: Colors.grey,
                                      icon: Icons.archive_outlined,
                                      onTap: () { archiveCase(cases[index]);},
                                    )
                                        : SizedBox(),
                                  ],
                                )
                              );
                            })),
                  ),
                )
              ]),
            ),
            floatingActionButton: Visibility(
              visible: isAdmin,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  // _fetchCases();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCustomForm()));
                },
                child: Icon(Icons.add) ,
              ),
            ),
          );
  }
  void deleteCase(_case) async {
    EasyLoading.show(status: "Deleting...");
    await Database.deleteCase(docId: _case["id"]);
    _fetchCases();
    EasyLoading.dismiss();
  }
  
  void archiveCase(_case) async {
    EasyLoading.show(status: "Loading...");
    await Database.updateCase(name: _case["name"], description: _case["description"], tel: _case["tel"], state: _case["state"], docId: _case["id"], image: _case["image"], status: "Archive");

    EasyLoading.dismiss();
  }
}

