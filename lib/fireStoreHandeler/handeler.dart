import 'package:cloud_firestore/cloud_firestore.dart';

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
      "followings": [],
      "comentedComent": []
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

class GetUserData {
  CollectionReference<Map<String, dynamic>> firestore =
      FirebaseFirestore.instance.collection("users");
  Future<String?> getUserName(String? userUID) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc(userUID);
    String? userName;
    await ref.get().then((value) {
      userName = value["userName"];
    });
    return userName;
  }

  getUserPhotoUrl(String? userUID) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection("users").doc(userUID);
    String? userPhotoUrl;
    ref.get().then((value) {
      userPhotoUrl = value["photoUrl"];
    });
    return userPhotoUrl;
  }
}
