import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBaseService {
  //DataBaseService({this.uid});
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('_CtnSignUp');

  FirebaseStorage storage =
      FirebaseStorage(storageBucket: "gs://rydgo-a1743.appspot.com");

  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  Future updateUserData(String name, String gender, String email) async {
    return await _collectionReference
        .doc(uid)
        .set({'name': name, 'gender': gender, 'email': email});
  }

  Future<String> getCollectionRef() async {
    DocumentReference dbref = FirebaseFirestore.instance
        .collection('_CtnSignUp')
        .doc(FirebaseAuth.instance.currentUser.uid);

    DocumentSnapshot snapshot = await dbref.get();
    if (snapshot.exists) {
      return "true";
    } else {
      return null;
    }
  }

  Future<String> uploadProfile(File file) async {
    var storageRef = storage.ref().child("user/profile/$uid");
    var uploadTask = storageRef.putFile(file);
    var completeTask = await uploadTask.onComplete;
    String downloadUrl = await completeTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getUserProfile() async {
    var storageRef = storage.ref().child("user/profile/$uid");
    return await storageRef.getDownloadURL();
  }

  static Future<String> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    var token;

    await _db.collection('_CtnSignUp').doc(userId).get().then((value) {
      token = value.id;
    });
    // var token;
    // await _db
    //     .collection('_CtnSignUp')
    //     .doc(userId)
    //     .collection('_CtnSignUp')
    //     .get()
    //     .then((snapshot) {
    //   snapshot.docs.forEach((doc) {
    //     token = doc.id;
    //   });
    // });

    return token;
  }
}
