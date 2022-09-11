import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/global.dart';

deleteAPost(postID, List postUsersThatSavedIt, String? userWhoCreatedThePost,
    String? postImageName) async {
  DocumentReference ref =
      FirebaseFirestore.instance.collection("posts").doc(postID);

  List usersWhoSavedThePost = [];
  for (var element in postUsersThatSavedIt) {
    usersWhoSavedThePost.add(element);
  }

  for (var users in usersWhoSavedThePost) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(users);

    List userSavedPost = [];
    userRef.get().then((data) async {
      userSavedPost = data["savedPost"];
      userSavedPost.remove(postID);
      postUsersThatSavedIt.remove(users);
      await userRef.update({"savedPost": userSavedPost});
    });
  }
  // removing the post from the created Posts
  var currentUserCreatedPost;
  FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((data) async {
    currentUserCreatedPost = data["createdPost"];
    currentUserCreatedPost.remove(postID);
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "createdPost": currentUserCreatedPost,
    });
  });
  // removing the post from the posts collection
  await ref.delete();
  // deleting the post image from the storage
  await FirebaseStorage.instance
      .ref("posts")
      .child("images")
      .child(postImageName!)
      .delete();
  Fluttertoast.showToast(msg: "Post have been deleted successfully");
}
