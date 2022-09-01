import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeUserData {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> changeUserName(String newUserName, String userUID) async {
    CollectionReference usersColl = firestore.collection("users");
    await usersColl.doc(userUID).update({"userName": newUserName});
  }

  Future<void> changeUserProfilePhoto(
      String newUserProfilePhotoUrl, String userUID) async {
    CollectionReference usersColl = firestore.collection("users");
    await usersColl.doc(userUID).update({"photoUrl": newUserProfilePhotoUrl});
  }

  Future<void> changeUserEmail(String newUserEmail, String userUID) async {
    CollectionReference usersColl = firestore.collection("users");
    await usersColl.doc(userUID).update({"Email": newUserEmail});
  }
}
