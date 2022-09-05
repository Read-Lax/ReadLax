import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readlex/shared/global.dart';

createNewPost() {
  String imageName = "";
  var pickedImageToPost = File("");
  final ImagePicker picker = ImagePicker();
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                                  final imagePicker = await picker.pickImage(
                                    source: ImageSource.camera,
                                  );
                                  pickedImageToPost = File(imagePicker!.path);
                                  Navigator.pop(context);
                                  imageName = imagePicker.name;
                                },
                                icon: const Icon(Icons.add_a_photo_outlined),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final imagePicker = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    pickedImageToPost = File(imagePicker!.path);
                                    imageName = imagePicker.name;
                                    Navigator.pop(context);
                                  },
                                  icon:
                                      const Icon(Icons.photo_library_rounded)),
                            ],
                          ),
                        ));
              },
              icon: Icon(
                Icons.add_photo_alternate_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
                onPressed: () {
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
    userRef
        .update({'createdPost': FieldValue.arrayUnion(allTheCurrentUserPosts)});
  });

  Fluttertoast.showToast(msg: "Post successfully uploaded");
}
