import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices {
  //collection info
  static CollectionReference totalDocCollections = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('UserCreds');

  //Firebase user data fetch
  static Stream<QuerySnapshot> getUserStreamSnapshot(
      BuildContext context) async* {
    final firebaseUsers = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("UserData")
        .doc(firebaseUsers)
        .collection('UserCreds')
        .snapshots();
  }

  //Firebase user data fetch
  static Stream<QuerySnapshot> getUserNotesSnapshot(
      BuildContext context) async* {
    final firebaseUsers = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("Notes")
        .doc(firebaseUsers)
        .collection('BackUpCodes')
        .snapshots();
  }

  //Firebase user data Image fetch
  static Stream<QuerySnapshot> getImageSnapshot(BuildContext context) async* {
    final firebaseUsers = FirebaseAuth.instance.currentUser!.uid;
    yield* FirebaseFirestore.instance
        .collection("UserData")
        .doc(firebaseUsers)
        .collection('UserCreds')
        .snapshots();

    //Firebase Retrive to homepage
  }
}
