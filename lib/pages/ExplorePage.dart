import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:readlex/fireStoreHandeler/handeler.dart';
import 'package:readmore/readmore.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:numeral/numeral.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:io';
import 'package:readlex/shared/mostUsedFunctions.dart';

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
            return const Center(child: Loading());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }
          final dataOfPosts = snapshot.requireData;
          DocumentReference ref =
              FirebaseFirestore.instance.collection("users").doc(user!.uid);
          return Scaffold(
            body: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                QueryDocumentSnapshot<Object?> currentDocs =
                    dataOfPosts.docs[index];
                
                return showPost(dataOfPosts.docs[index], context);
              },
              itemCount: snapshot.data!.size,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => createNewPost());
              },
              focusColor: Colors.teal,
              elevation: 5,
              child: const Icon(
                Icons.add_box_outlined,
              ),
            ),
          );
        });
  }

  createNewPost() {
    bool isImageSelected = false;
    String selectedPhotoUrl = "";
    String imageName = "";
    var pickedImageToPost;
    late Widget returnImageOrText = const Text("No Image Selected");
    TextEditingController userPost = TextEditingController();
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return AlertDialog(
            title: const Center(
                child: ListTile(
              leading: Icon(
                Icons.post_add_outlined,
                size: 35,
              ),
              title: Text(
                "New Post",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    // obscureText: true,
                    controller: userPost,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hoverColor: Colors.greenAccent,
                      fillColor: Colors.black,
                      border: UnderlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      // OutlineInputBorder(
                      // borderRadius:
                      // BorderRadius.all(Radius.circular(10.0))
                      label: Text(
                        "Share what you think...",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          // color: Colors.teal,
                          fontSize: 15,
                          // color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Container(child: returnImageOrText)
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text(
                              "Select:",
                              style: TextStyle(
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      final imagePicker =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        // maxHeight: 513,
                                        // maxWidth: 513,
                                        imageQuality: 100,
                                      );
                                      pickedImageToPost =
                                          File(imagePicker!.path);
                                      Navigator.pop(context);
                                    },
                                    icon:
                                        const Icon(Icons.add_a_photo_outlined)),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final imagePicker =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        // maxHeight: 513,
                                        // maxWidth: 513,
                                        imageQuality: 100,
                                      );
                                      pickedImageToPost =
                                          File(imagePicker!.path);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        Icons.photo_library_rounded)),
                              ],
                            ),
                          ));
                },
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.green[50],
                ),
              ),
              IconButton(
                  onPressed: () {
                    // if (userPost.text.trim() == null) {
                    //   Fluttertoast.showToast(
                    //       msg: "Text is requiered",
                    //       timeInSecForIosWeb: 5,);
                    // }
                    postTheInfo(
                        userPost.text.trim(), pickedImageToPost, imageName);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.done_all_rounded,
                    color: Colors.greenAccent,
                  ))
            ],
          );
        });
  }

  returnImageInTheDialoque(isImageSelected, photoUrl) {
    if (isImageSelected) {
      setState(() {});
    } else {
      return const Center(
        child: Text("No Image Selected"),
      );
    }
  }

  postTheInfo(String text, var photoData, String imageName) async {
    String? photoUrl;
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection("posts").doc();

    Reference storageRef =
        FirebaseStorage.instance.ref("posts").child("images").child(imageName);

    Fluttertoast.showToast(msg: "Uploading your post...");
    await storageRef.putFile(photoData);
    await storageRef
        .getDownloadURL()
        .then((storageData) => photoUrl = storageData.toString());
    await ref.set({
      "userName": user!.displayName,
      "userUID": user!.uid,
      "content": text,
      "photoUrl": photoUrl,
      // "date": DateTime(
      // DateTime.now().year, DateTime.now().month, DateTime.now().day),
      "year": DateTime.now().year,
      "month": DateTime.now().month,
      "day": DateTime.now().day,
      "hour": DateTime.now().hour,
      "userProfilePicUrl": user!.photoURL,
      "likes": 0,
      "likedBy": [],
      "savedBy": [],
      "imageName": imageName
    });
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);
    await userRef.get().then((userPost) {
      List allTheCurrentUserPosts = userPost['createdPost'];
      allTheCurrentUserPosts.add(ref.id);
      userRef.update(
          {'createdPost': FieldValue.arrayUnion(allTheCurrentUserPosts)});
    });

    Fluttertoast.showToast(msg: "Post successfully uploaded");
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
