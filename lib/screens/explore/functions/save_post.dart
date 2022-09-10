import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/global.dart';

savePost(postId, List postUsersThatSaveThePost) async {
  DocumentSnapshot ref =
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  List savedPost = [];
  String? operationEndMsg;
  savedPost = ref.get("savedPost"); // new way to get data from firestore
  if (postUsersThatSaveThePost.contains(user!.uid)) {
    savedPost.remove(postId);
    postUsersThatSaveThePost.remove(user!.uid);
    operationEndMsg = "Post have been removed from saved post";
  } else {
    // isAlreadySaved = false;
    savedPost.add(postId);
    postUsersThatSaveThePost.add(user!.uid);
    operationEndMsg = "Post have been saved";
  }

  FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
    "savedPost": savedPost,
  });
  FirebaseFirestore.instance
      .collection("posts")
      .doc(postId)
      .update({"savedBy": postUsersThatSaveThePost});
  Fluttertoast.showToast(msg: operationEndMsg);
}