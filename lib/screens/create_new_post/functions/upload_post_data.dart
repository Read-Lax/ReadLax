import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/global.dart';

postTheInfo(String text, var photoData, String imageName) async {
  String? photoUrl;
  DocumentReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection("posts").doc();

  Reference storageRef =
      FirebaseStorage.instance.ref("posts").child("images").child(imageName);

  Fluttertoast.showToast(
      msg: "Publishing your post... this may take some minutes.");
  await storageRef.putFile(photoData);
  // Fluttertoast.showToast(msg: "Done file upload");
  await storageRef
      .getDownloadURL()
      .then((storageData) => photoUrl = storageData.toString());
  await ref.set({
    "userName": user!.displayName,
    "userUID": user!.uid,
    "content": text,
    "photoUrl": photoUrl,
    "year": DateTime.now().year,
    "month": DateTime.now().month,
    "day": DateTime.now().day,
    "hour": DateTime.now().hour,
    "userProfilePicUrl": user!.photoURL,
    "likes": 0,
    "likedBy": [],
    "savedBy": [],
    "imageName": imageName,
    "usersWhoComented": []
  });
  DocumentReference<Map<String, dynamic>> userRef =
      FirebaseFirestore.instance.collection("users").doc(user!.uid);
  await userRef.get().then((userPost) {
    List allTheCurrentUserPosts = userPost['createdPost'];
    allTheCurrentUserPosts.add(ref.id);
    userRef
        .update({'createdPost': FieldValue.arrayUnion(allTheCurrentUserPosts)});
  });

  Fluttertoast.showToast(msg: "Post successfully uploaded");
}