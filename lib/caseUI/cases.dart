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
  bool canManage = false;
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
      if(querySnapshot.data()["role"] == "User"){
        global.isAdmin = false,
        setState(() => {
          canManage = false
        })
      } else {
        global.isAdmin = true,
        setState(() => {
          canManage = true
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "${auth.currentUser.displayName}, Welcome to iHssan app where you can help and get help!",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: "Hide",
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      EasyLoading.dismiss();
      // print(cases);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                                      cases[index]['state'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onTap:() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => showCase(item: cases[index])));

                                    },
                                  ),
                                  actions: <Widget>[
                                    canManage ? new IconSlideAction(
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
                                   //  isAdmin ?
                                   //  new IconSlideAction(
                                   //    caption: 'Delete',
                                   //    color: Colors.red,
                                   //    icon: Icons.delete,
                                   //    onTap: () { deleteCase(cases[index]);},
                                   //  )
                                   // : SizedBox(),
                                    canManage ?
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
              visible: canManage,
              child: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
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
    _fetchCases();
    EasyLoading.dismiss();
  }
}

