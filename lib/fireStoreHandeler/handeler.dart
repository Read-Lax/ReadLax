import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> writeNewUserData(String userName, String userEmail,
    String userPhotoUrl, String userUID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersColl = firestore.collection("users");
  await usersColl.doc(userUID).set(
    {
      "userName": userName,
      "Email": userEmail,
      "photoUrl": userPhotoUrl,
      "savedPost": [],
      "createdPost": [],
      "description": "",
      "followers": [],
      "followings": []
    },
    SetOptions(merge: true),
  );
}

class MakeInfoChangesIntoUser {
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

class CurrentUserData {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  getUserName(String? userUID) {
    CollectionReference usersColl = firestore.collection("users");
    Object? userName = usersColl.doc(userUID).get();
    // print(userName["userName"]); // return userName;
    return "UserName";
  }
}
