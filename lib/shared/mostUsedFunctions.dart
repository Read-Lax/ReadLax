import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:numeral/numeral.dart';
import 'package:readlex/shared/global.dart';
import 'package:readmore/readmore.dart';
import 'package:readlex/screens/explore/coments/post_coments.dart';
import 'package:intl/intl.dart' as intl;

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: const SpinKitCubeGrid(
        color: Colors.greenAccent,
        size: 50.0,
      ),
    );
  }
}



addPostToFavorite(postId, List postUsersThatSaveThePost) async {
  DocumentSnapshot ref =
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  List savedPost = [];

  String? operationEndMsg;
  // List data;
  List isALreadySaveds;
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


deleteAPost(postID, List postUsersThatSavedIt, String? userWhoCreatedThePost,
    String? postImageName) async {
  DocumentReference ref =
      FirebaseFirestore.instance.collection("posts").doc(postID);

  List usersWhoSavedThePost = [];
  postUsersThatSavedIt.forEach((element) {
    usersWhoSavedThePost.add(element);
  });

  for (var users in usersWhoSavedThePost) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(users);

    List userSavedPost = [];
    userRef.get().then((value) => userSavedPost = value["savedPost"]);
    userSavedPost.remove(postID);
    postUsersThatSavedIt.remove(users);
    await userRef.update({"savedPost": userSavedPost});
  }
  // removing the post from the created Posts
  List currentUserCreaterPost = [];
  DocumentReference userRef =
      FirebaseFirestore.instance.collection("users").doc(userWhoCreatedThePost);
  userRef.get().then((data) => currentUserCreaterPost = data["createdPost"]);
  currentUserCreaterPost.remove(postID);
  await userRef.update({"createdPost": currentUserCreaterPost});
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

/* 
  Coments functions
*/
// upload or publish a coment
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

// delete a coment
deleteAComent(String? comentUID, String? postUID,
    String? userUIDwhoCreatedTheComent) async {
  DocumentReference comentRef = FirebaseFirestore.instance
      .collection("posts")
      .doc(postUID)
      .collection("coments")
      .doc(comentUID);

  await comentRef.delete();
  Fluttertoast.showToast(msg: "coment deleted successfully");
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userUIDwhoCreatedTheComent)
      .update({
    "comentedComents": FieldValue.arrayRemove([
      {"comentUID": comentUID, "postUID": postUID}
    ])
  });
  // Fluttertoast.showToast(msg: "coment deleted successfully");
}

// report Class
// for reporting Indecent Coments, posts, khatmat
class Report {
  // this class contains functions that made for reporting In-app content
  // like [Coments, post, khatma]
  // and the way it works is by uploading data about the reported content and the user who created it to a collection
  // in firebase firestore and then it will be veiwed by the devloper and get deleted if it againsed the terms and conditions

  void reportComents(String? commentUserUID, String? comentUID) async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc("b347WbgYL9au4kAFSrzI")
        .update({
      "coments": FieldValue.arrayUnion([
        {"comentUID": comentUID, "comentUserUID": commentUserUID}
      ])
    });
  }

  void reportPost(String? postUserUID, String? postUID) async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc("b347WbgYL9au4kAFSrzI")
        .update({
      "posts": FieldValue.arrayUnion([
        {"comentUID": postUID, "comentUserUID": postUserUID}
      ])
    });
  }
}
