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
    userRef.get().then((value) async {
      userSavedPost = value["savedPost"];
      userSavedPost.remove(postID);
      postUsersThatSavedIt.remove(users);
      await userRef.update({"savedPost": userSavedPost});
    });
  }
  // removing the post from the created Posts
  List currentUserCreaterPost = [];
  DocumentReference currentUserRef =
      FirebaseFirestore.instance.collection("users").doc(user!.uid);
  await currentUserRef.get().then((data) async {
    currentUserCreaterPost = data["createdPost"];
    currentUserCreaterPost.remove(postID);
    await currentUserRef
        .update({"createdPost": FieldValue.arrayUnion(currentUserCreaterPost)});
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
