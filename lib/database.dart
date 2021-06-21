import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('cases');

class Database{

  static String userUid;


  // add cases
  static Future<void> addCase({
    @required String name,
    @required String description,
    @required String tel,
   @required String state,
   @required String image,
    @required String status,

  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "tel": tel,
      "state": state,
      "image": image,
      "status": status,

    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("case  added to the database"))
        .catchError((e) => print(e));
  }

//read cases

  Stream<QuerySnapshot> get readCases {

    CollectionReference casesItemCollection =
    _mainCollection.doc(userUid).collection('cases');

    return casesItemCollection.snapshots();
  }


//update cases

  static Future<void> updateCase({
    @required String name,
    @required String description,
    @required String tel,
    @required String state,
    @required String docId,
    @required String image,
    @required String status,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "description": description,
      "tel": tel,
      "state": state,
      "image": image,
      "status": status
    };
    await documentReferencer
        .update(data)
        .whenComplete(() => print("case item updated in the database"))
        .catchError((e) => print(e));
  }

  //delete cases
  static Future<void> deleteCase({
    @required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Case item deleted from the database'))
        .catchError((e) => print(e));
  }
}
