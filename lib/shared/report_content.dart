import 'package:cloud_firestore/cloud_firestore.dart';


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
