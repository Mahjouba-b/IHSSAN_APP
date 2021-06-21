import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:ihssan_app/UserLogin/logIn.dart';
import 'package:ihssan_app/admin/createUser.dart';
import 'package:ihssan_app/admin/updateUser.dart';
import 'package:ihssan_app/admin/users.dart';
import 'package:ihssan_app/caseUI/archivedCases.dart';
import 'package:ihssan_app/caseUI/cases.dart';
import 'global.dart' as global;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAdmin = false;
  List<ScreenHiddenDrawer> items = [];

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {

    _userRole();
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Cases",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 18.0 ),
          colorLineSelected: Colors.orange,
        ),
        Cases()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Archived Cases",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 18.0 ),
          colorLineSelected: Colors.orange,
        ),
        ArchivedCases()));
    //
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Update Profile",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 18.0 ),
          colorLineSelected: Colors.orange,
        ),
        UpdateUser()));

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

    _initScreen();
  }

  void _initScreen() {

    if(isAdmin){
      items.add(new ScreenHiddenDrawer(
          new ItemHiddenMenu(
            name: "Users",
            baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 18.0 ),
            colorLineSelected: Colors.orange,
          ),
          Users()));
    }

  }

  void _handleLogout() {
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
             onPressed: () {
               EasyLoading.show(status: "Loggin Out...");
               auth.signOut();
               EasyLoading.dismiss();
               Navigator.push(context,
                   MaterialPageRoute(builder: (context) => LogIn()));

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
             onPressed: () {
               EasyLoading.show(status: "Loggin Out...");
               auth.signOut();
               EasyLoading.dismiss();
               Navigator.push(context,
                   MaterialPageRoute(builder: (context) => LogIn()));

             },
             child: Text("Yes")
         ),
       ],
     );
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple[500],
      backgroundColorAppBar: Colors.orangeAccent[200],
      // initPositionSelected: 0,
      slidePercent: 50,
      screens: items,
      //    typeOpen: TypeOpen.FROM_RIGHT,
         disableAppBarDefault: false,
      //    enableScaleAnimin: true,
      //    enableCornerAnimin: true,
      //    slidePercent: 80.0,
      //    verticalScalePercent: 80.0,
      //    contentCornerRadius: 10.0,
      //    iconMenuAppBar: Icon(Icons.menu),
      //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
      //    whithAutoTittleName: true,
      //    styleAutoTittleName: TextStyle(color: Colors.red),
         actionsAppBar: <Widget>[
          TextButton(
            onPressed: () {
              _handleLogout();
            },
            child: Icon(Icons.logout, color: Colors.deepPurple,)),
         ],
      //    backgroundColorContent: Colors.blue,
      //    elevationAppBar: 4.0,
      //    tittleAppBar: Center(child: Icon(Icons.ac_unit),),
      //    enableShadowitemsMenu: true,
      //    backgroundMenu: DecorationImage(image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
    );
  }
}
