import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:readlex/utils/create_new_post.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> firestoreStream =
      FirebaseFirestore.instance.collection("posts").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: SpinKitCircle(
              color: Colors.greenAccent,
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.greenAccent,
              ),
            );
          }
          final dataOfPosts = snapshot.requireData;
          DocumentReference ref =
              FirebaseFirestore.instance.collection("users").doc(user!.uid);
          return Scaffold(
            body: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                QueryDocumentSnapshot<Object?> currentDocs =
                    dataOfPosts.docs[index];
                return showPost(currentDocs, context);
              },
              itemCount: snapshot.data!.size,
            ),
          );
        });
  }

  addPostToFavorite(postId, isAlreadySaved) async {
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);
    List savedPost = [];
    // int isAlreadySaved = false;
    String? operationEndMsg;
    ref.get().then((value) {
      savedPost = value["savedPost"];
      if (savedPost.contains(postId)) {
        isAlreadySaved = true;
      } else {
        isAlreadySaved = false;
      }
    });
    if (isAlreadySaved) {
      savedPost.remove(postId);
      operationEndMsg = "Post have been removed from saved post";
    } else {
      savedPost.add(postId);
      operationEndMsg = "Post have been saved";
    }

    ref.update({
      "savedPost": savedPost,
    });
    Fluttertoast.showToast(msg: operationEndMsg);
  }
}
