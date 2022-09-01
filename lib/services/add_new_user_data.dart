import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNewUserData(String userName, String userEmail,
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