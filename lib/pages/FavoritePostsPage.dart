import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:readmore/readmore.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({Key? key}) : super(key: key);

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  Stream<QuerySnapshot> ref =
      FirebaseFirestore.instance.collection("users").snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          User? user = FirebaseAuth.instance.currentUser;
          final dataOfPosts = snapshot.requireData;
          List savedPost = [];
          int userIndex = 0;
          int k = 0;
          for (var i in dataOfPosts.docs) {
            if (user!.uid == dataOfPosts.docs[k].reference.id) {
              userIndex = k;
            }
            k += 1;
          }
          final currentUserData = dataOfPosts.docs[userIndex];
          for (var i in currentUserData['savedPost']) {
            savedPost.add(i);
          }
          bool isPostAlreadySaved = false;

          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Saved Posts",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: "VareLaRound",
                    letterSpacing: 2,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var feildData;
                  String? postUsersPhotoURL = "";
                  String? postUserDisplayName = "";
                  String? postUsersUid = "";
                  String? postContent = "";
                  String? postPhotoURL = "";

                  CollectionReference<Map<String, dynamic>> ref =
                      FirebaseFirestore.instance.collection("posts");
                  final postData = ref.doc(savedPost[index]);
                  postData.get().then((value) => feildData = value);
                  // postUsersPhotoURL = feildData["userProfilePicUrl"];
                  // postUserDisplayName = feildData["userName"];
                  // postUsersUid = feildData["userUID"];
                  // postContent = feildData["content"];
                  // postPhotoURL = feildData["photoUrl"];
                  return Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                              onTap: () {},
                              leading: CircleAvatar(
                                backgroundImage: Image.network(
                                        "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/quran%2F1.png?alt=media")
                                    .image,
                                radius: 30.0,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            content: Column(
                                              children: [
                                                Card(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                  elevation: 0,
                                                  child: ListTile(
                                                      trailing:
                                                          isPostAlreadySaved
                                                              ? const Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 20,
                                                                )
                                                              : const Text(""),
                                                      leading: const Icon(
                                                        Icons.add_to_photos,
                                                        size: 25,
                                                      ),
                                                      title: const Text("Save",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "VareLaRound",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            // color: Colors.black
                                                          )),
                                                      onTap: () {
                                                        addPostToFavorite(
                                                            currentUserData.id);
                                                        Navigator.pop(context);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Post have been saved successfully");
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ));
                                },
                                icon: const Icon(Icons.more_vert_rounded),
                              ),
                              title: Text(
                                // postUserDisplayName!,
                                feildData["userName"],
                                style: const TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ReadMoreText(
                              postContent!,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontWeight: FontWeight.w200),
                            ),
                          ),
                          Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/readlex-app-5d379.appspot.com/o/quran%2F1.png?alt=media",
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: savedPost.length,
              ));
        });
  }

  addPostToFavorite(postId) async {
    DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    List savedPost = [];
    ref.get().then((value) {
      // print(value['userName']);
      savedPost = value["savedPost"];
    });
    savedPost.add(postId);
    ref.update({
      "savedPost": FieldValue.arrayUnion(savedPost),
    });
  }
}
