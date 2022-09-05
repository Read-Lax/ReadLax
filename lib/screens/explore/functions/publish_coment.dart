// upload or publish a coment
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

uploadAComent(String? postUID, String? commentContent, String? userUID) async {
  // await user!.reload();
  CollectionReference<Map<String, dynamic>> postComentRef = FirebaseFirestore
      .instance
      .collection("posts")
      .doc(postUID)
      .collection("coments");
  // Fluttertoast.showToast(msg: postUID!);
  String? commentUID;
  await postComentRef.add({
    "comentContent": commentContent,
    "comentUserUID": userUID,
    "comentTime": DateTime.now(),
    "userPhotoUrl": FirebaseAuth.instance.currentUser!.photoURL,
    "userName": FirebaseAuth.instance.currentUser!.displayName,
    "hour": DateTime.now().hour,
    "day": DateTime.now().day,
    "year": DateTime.now().year,
    "month": DateTime.now().month,
    "likedBy": [],
  }).then((value) => commentUID = value.id);
  Fluttertoast.showToast(msg: "coment got published successfully");
  await FirebaseFirestore.instance.collection("users").doc(userUID!).update({
    "comentedComents": FieldValue.arrayUnion([
      {"comentUID": commentUID, "postUID": postUID}
    ])
  });
  // Fluttertoast.showToast(msg: "coment got published successfully");
}