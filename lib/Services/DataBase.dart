import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {
  //DataBaseService({this.uid});
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Safar');

  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  Future updateUserData(String name, String gender, String email) async {
    return await _collectionReference
        .doc(uid)
        .set({'name': name, 'gender': gender, 'email': email});
  }
}
