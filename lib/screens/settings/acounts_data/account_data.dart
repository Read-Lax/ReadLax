import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
import 'package:readlex/main.dart';
import 'package:readlex/providers/theme_provider/theme_provider.dart';
import 'dart:io';
import 'package:readlex/services/change_user_data.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? userImage = "";
  String? userName = "";
  String? userGmail = "";
  String? userPhoneNumber = "";
  // Text controllers
  TextEditingController newUserName = TextEditingController();
  TextEditingController newUserEmail = TextEditingController();
  TextEditingController newUserPhoneNumber = TextEditingController();
  TextEditingController repeatedUserPassword = TextEditingController();
  TextEditingController userEnterdPassword = TextEditingController();
  TextEditingController userDescription = TextEditingController();
  var oldUserDesc;

  final Stream<QuerySnapshot> firestoreUserData =
      FirebaseFirestore.instance.collection("users").snapshots();
  ChangeUserData userChanges = ChangeUserData();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreUserData,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingCircule();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingCircule();
          }
          final data = snapshot.requireData;
          int userIndex = 0;
          int k = 0;
          for (var i in data.docs) {
            if (currentUser!.uid == data.docs[k].reference.id) {
              userIndex = k;
            }
            k += 1;
          }
          newUserEmail.text = data.docs[userIndex]["Email"];
          newUserName.text = data.docs[userIndex]["userName"];
          userImage = data.docs[userIndex]["photoUrl"];
          userDescription.text = data.docs[userIndex]["description"];
          oldUserDesc = data.docs[userIndex]["description"];
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                color: Theme.of(context).primaryColor,
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                "Account Settings",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontSize: 25,
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        " • Profile Picture",
                        // textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontFamily: "VareLaRound",
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color:
                                Provider.of<ThemeProvider>(context).isDarkMode
                                    ? Colors.white60
                                    : Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Stack(children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.greenAccent,
                                ),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      userImage!,
                                    ))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                color: Colors.white,
                                onPressed: () async {
                                  final List<AssetEntity>? userPicke =
                                      await AssetPicker.pickAssets(context,
                                          pickerConfig: const AssetPickerConfig(
                                            maxAssets: 1,
                                            requestType: RequestType.image,
                                          ));
                                  try {
                                    File? imageFile =
                                        await userPicke!.first.file;
                                    uploadProfilePic(imageFile);
                                    // ignore: empty_catches
                                  } catch (error) {}
                                },
                              ),
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // const Divider(),
                  Row(
                    children: [
                      Text(
                        " • Account's Info",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontSize: 20,
                          color: Provider.of<ThemeProvider>(context).isDarkMode
                              ? Colors.white60
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        TextField(
                          dragStartBehavior: DragStartBehavior.start,
                          autofocus: false,
                          controller: newUserName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            label: Text(
                              "Display name",
                              style: TextStyle(
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        TextField(
                          controller: newUserEmail,
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                // color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        TextField(
                          maxLines: null,
                          maxLength: 1500,
                          controller: userDescription,
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            label: Text(
                              "bio",
                              style: TextStyle(
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        // TextField(
                        //   controller: newUserPhoneNumber,
                        //   decoration: const InputDecoration(
                        //     fillColor: Colors.black,
                        //     border: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(20.0))),
                        //     label: Text(
                        //       "Phone Number",
                        //       style: TextStyle(
                        //         fontFamily: "VareLaRound",
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.greenAccent,
                        //         // color: Colors.black45,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // const Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Card(
                  //     elevation: 5,
                  //     shape: const RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20))),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Column(
                  //         children: [
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //           const Text(
                  //             "Change Account's Password",
                  //             textDirection: TextDirection.ltr,
                  //             style: TextStyle(
                  //               fontFamily: "VareLaRound",
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //           TextField(
                  //             // obscureText: true,
                  //             autofocus: true,
                  //             controller: userEnterdPassword,
                  //             // cursorColor: Colors.black,
                  //             decoration: const InputDecoration(
                  //               fillColor: Colors.black,
                  //               border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.circular(10.0))),
                  //               label: Text(
                  //                 "New password",
                  //                 style: TextStyle(
                  //                   fontSize: 15,
                  //                   fontFamily: "VareLaRound",
                  //                   fontWeight: FontWeight.bold,
                  //                   // color: Colors.black45,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             height: 7,
                  //           ),
                  //           TextField(
                  //             // obscureText: true,
                  //             autofocus: true,
                  //             controller: repeatedUserPassword,
                  //             // cursorColor: Colors.black,
                  //             decoration: const InputDecoration(
                  //               fillColor: Colors.black,
                  //               border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.circular(10.0))),
                  //               label: Text(
                  //                 "Repeat Password",
                  //                 style: TextStyle(
                  //                   fontSize: 15,
                  //                   fontFamily: "VareLaRound",
                  //                   fontWeight: FontWeight.bold,
                  //                   // color: Colors.black45,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.greenAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.greenAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))))),
                          onPressed: () {
                            applayProfileChanges();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void changeDisplayName(newName) async {
    if (currentUser!.displayName != newName) {
      await currentUser!.updateDisplayName(newName);
      userChanges.changeUserName(newName, currentUser!.uid);
      DocumentReference<Map<String, dynamic>> ref =
          FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);
      await ref.get().then((posts) async {
        List currentUserPosts = posts['createdPost'];
        for (var postItem in currentUserPosts) {
          DocumentReference<Map<String, dynamic>> postRef =
              FirebaseFirestore.instance.collection("posts").doc(postItem);
          await postRef.update({'userName': newName});
        }
        List comentedComents = [];
        ref.get().then((userData) async {
          comentedComents = userData["comentedComents"];
          print(comentedComents);
          for (var coment in comentedComents) {
            await FirebaseFirestore.instance
                .collection("posts")
                .doc(coment["postUID"])
                .collection("coments")
                .doc(coment["comentUID"])
                .update({"userName": newName});
          }
        });
      });
    }
  }

  void changeEmail(newEmail) async {
    if (currentUser!.email != newEmail) {
      await currentUser!.updateEmail(newEmail);
      userChanges.changeUserEmail(newEmail, currentUser!.uid);
    }
  }

  void updateUserDescription(newDesc, oldDesc) async {
    if (oldDesc != newDesc) {
      DocumentReference<Map<String, dynamic>> ref =
          FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);
      await ref.update({"description": newDesc});
    }
  }

  void passwordChange() async {
    if (repeatedUserPassword.text.trim() == userEnterdPassword.text.trim()) {
      await currentUser!
          .updatePassword(repeatedUserPassword.text.trim())
          .whenComplete(() => FirebaseAuth.instance.signOut());
      setState(() {});
      // Navigator.push(
      //     context, MaterialPageRoute(builder: ((context) => const ShowPage())));
    } else {
      Fluttertoast.showToast(msg: "Passwords Doesn't match, please try again");
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const ShowPage())));
    }
  }

  uploadProfilePic(ImagePath) async {
    Reference ref = FirebaseStorage.instance
        .ref("users")
        .child(currentUser!.uid)
        .child("profilepic.png");
    await ref.putFile(ImagePath);
    await ref.getDownloadURL().then((value) async {
      currentUser!.updatePhotoURL(value);
      userChanges.changeUserProfilePhoto(value, currentUser!.uid);
      DocumentReference<Map<String, dynamic>> ref =
          FirebaseFirestore.instance.collection("users").doc(currentUser!.uid);
      await ref.get().then((posts) async {
        List currentUserPosts = posts['createdPost'];
        for (var postItem in currentUserPosts) {
          DocumentReference<Map<String, dynamic>> postRef =
              FirebaseFirestore.instance.collection("posts").doc(postItem);
          await postRef.update({'userProfilePicUrl': value});
        }
      });
      List comentedComents = [];
      ref.get().then((userData) async {
        comentedComents = userData["comentedComents"];
        for (var coment in comentedComents) {
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(coment["postUID"])
              .collection("coments")
              .doc(coment["comentUID"])
              .update({"userPhotoUrl": value});
        }
      });
    });
  }

  applayProfileChanges() async {
    try {
      changeDisplayName(newUserName.text.trim());
      changeEmail(newUserEmail.text.trim());
      updateUserDescription(userDescription.text.trim(), oldUserDesc);
      // passwordChange();
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message!);
    }
    Fluttertoast.showToast(msg: "Changes saved successfully");
  }
}
