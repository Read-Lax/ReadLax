import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:readlex/fireStoreHandeler/handeler.dart';
import 'package:readmore/readmore.dart';
import 'package:readlex/shared/loadingScreen.dart';
import 'package:numeral/numeral.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:io';

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

                String? postUsersPhotoURL = currentDocs["userProfilePicUrl"];
                String? postUserDisplayName = currentDocs["userName"];
                String? postUsersUid = currentDocs["userUID"];
                String? postContent = currentDocs["content"];
                String? postPhotoURL = currentDocs["photoUrl"];
                List postUsersThatLikedIt = currentDocs['likedBy'];
                int? postLikes = currentDocs["likes"];
                List savedPost = [];
                int postHour = currentDocs['hour'];
                int postYear = currentDocs["year"];
                int postMonth = currentDocs["month"];
                int postDay = currentDocs["day"];
                TextEditingController creatComment = TextEditingController();
                // String postTime =
                //     Jiffy(DateTime(postYear, postMonth, postDay)).fromNow();
                String postTime = Jiffy({
                  "year": postYear,
                  "day": postDay,
                  "month": postMonth,
                  "hour": postHour
                }).fromNow();
                Widget postHeartWidget;
                bool isPostAlreadySaved = false;
                ref.get().then((value) {
                  for (var i in value["savedPost"]) {
                    savedPost.add(i);
                    if (currentDocs.id == i) {
                      isPostAlreadySaved = true;
                    } else {
                      isPostAlreadySaved = false;
                    }
                  }
                });
                if (postUsersThatLikedIt.contains(user!.uid)) {
                  postHeartWidget = const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 35,
                  );
                } else {
                  postHeartWidget = const Icon(
                    Icons.favorite_border_sharp,
                    size: 35,
                  );
                }
                return Card(
                  elevation: 7,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        usersProfile(postUsersUid!, context))));
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                Image.network(postUsersPhotoURL!).image,
                            radius: 20.0,
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
                                                              Radius.circular(
                                                                  20))),
                                              elevation: 0,
                                              child: ListTile(
                                                  trailing: isPostAlreadySaved
                                                      ? const Icon(
                                                          Icons.done,
                                                          color: Colors.green,
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
                                                        currentDocs.id,
                                                        isPostAlreadySaved);
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                          title: Text(
                            "$postUserDisplayName\n • $postTime",
                            style: const TextStyle(
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        const Divider(),
                        Container(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ReadMoreText(
                              postContent!,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: "VareLaRound",
                                  fontWeight: FontWeight.w200),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          // child: Image.network(postPhotoURL!)
                          child: Image.network(
                            postPhotoURL!,
                            fit: BoxFit.contain,
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
                        ),
                        const Divider(),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Row(
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (postUsersThatLikedIt
                                        .contains(user!.uid)) {
                                      DocumentReference<Map<String, dynamic>>
                                          ref = FirebaseFirestore.instance
                                              .collection("posts")
                                              .doc(currentDocs.id);
                                      postUsersThatLikedIt.remove(user!.uid);
                                      ref.update({
                                        "likedBy": postUsersThatLikedIt,
                                        "likes": postLikes! - 1
                                      });
                                    } else {
                                      DocumentReference<Map<String, dynamic>>
                                          ref = FirebaseFirestore.instance
                                              .collection("posts")
                                              .doc(currentDocs.id);
                                      postUsersThatLikedIt.add(user!.uid);
                                      ref.update({
                                        "likedBy": FieldValue.arrayUnion(
                                            postUsersThatLikedIt),
                                        "likes": postLikes! + 1
                                      });
                                    }
                                  },
                                  icon: postHeartWidget,
                                ),
                                Text(
                                  Numeral(postLikes!).toString(),
                                  style: const TextStyle(
                                    fontFamily: "VareLaRound",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(
                            //       Icons.add_comment_outlined,
                            //       size: 33,
                            //     )),
                            // Container(
                            //   height: 20,
                            //   width: 90,
                            //   child: ListTile(
                            //     leading: CircleAvatar(
                            //       radius: 30.0,
                            //       backgroundImage:
                            //           Image.network(user!.photoURL!).image,
                            //     ),
                            //   ),
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                );
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
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hoverColor: Colors.greenAccent,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      label: Text(
                        "post",
                        style: TextStyle(
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.bold,
                            color: Colors.teal
                            // color: Colors.black45,
                            ),
                      ),
                    ),
                  ),
                  returnImageOrText
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
                                      if (isImageSelected) {
                                        Reference ref = FirebaseStorage.instance
                                            .ref("posts")
                                            .child("images")
                                            .child(imageName);
                                        await ref.delete();
                                        setState(() {
                                          isImageSelected = false;
                                        });
                                      }
                                      final imagePicker =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        maxHeight: 513,
                                        maxWidth: 513,
                                        imageQuality: 100,
                                      );
                                      Reference ref = FirebaseStorage.instance
                                          .ref("posts")
                                          .child("images")
                                          .child(imagePicker!.name);
                                      await ref.putFile(File(imagePicker.path));
                                      await ref.getDownloadURL().then((value) {
                                        setState(() {
                                          selectedPhotoUrl = value;
                                          isImageSelected = true;
                                          imageName = ref.name;
                                        });
                                        print(imageName);
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon:
                                        const Icon(Icons.add_a_photo_outlined)),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (isImageSelected) {
                                        Reference ref = FirebaseStorage.instance
                                            .ref("posts")
                                            .child("images")
                                            .child(imageName);
                                        await ref.delete();
                                        setState(() {
                                          isImageSelected = false;
                                        });
                                      }
                                      final imagePicker =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        // maxHeight: 513,
                                        // maxWidth: 513,
                                        imageQuality: 100,
                                      );
                                      Reference ref = FirebaseStorage.instance
                                          .ref("posts")
                                          .child("images")
                                          .child(imagePicker!.name);
                                      await ref.putFile(File(imagePicker.path));
                                      await ref.getDownloadURL().then((value) {
                                        setState(() {
                                          selectedPhotoUrl = value.toString();
                                          isImageSelected = true;
                                          imageName = ref.name;
                                          returnImageOrText =
                                              const Text("Hello");

                                          // Image.network(selectedPhotoUrl);
                                        });
                                        print(imageName);
                                        print(selectedPhotoUrl);
                                        Navigator.pop(context);
                                      });
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
                    postTheInfo(userPost.text.trim(), selectedPhotoUrl);
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

  usersProfile(userUid, context) {
    final Stream<QuerySnapshot> userRef =
        FirebaseFirestore.instance.collection("users").snapshots();

    var userData;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: userRef,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Loading(),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loading(),
              );
            }
            String? userName = "";
            String? userPhotoUrl = "";
            String? userDescription = "";
            List usersFollowers;
            List usersFollwings;
            List userCreatedPost;
            String? followButtonText = "Follow";
            IconData? followButtonIcon = Icons.person_add_alt;
            bool isFollowButtonEnabled = true;

            final userData = snapshot.requireData;
            int userIndex = 0;
            int k = 0;
            for (var i in userData.docs) {
              if (userUid == userData.docs[k].reference.id) {
                userIndex = k;
              }
              k += 1;
            }
            final currentUserData = snapshot.requireData;
            int currentUserIndex = 0;
            int g = 0;
            for (var i in currentUserData.docs) {
              if (user!.uid == currentUserData.docs[g].reference.id) {
                currentUserIndex = g;
              }
              g += 1;
            }
            List currentUserFollowing =
                currentUserData.docs[currentUserIndex]["followings"];
            if (currentUserFollowing.contains(userUid) == true) {
              followButtonText = "Unfollow";
              followButtonIcon = Icons.person_add_disabled_outlined;
            } else {
              followButtonText = "Follow";
              followButtonIcon = Icons.person_add_alt;
            }
            if (user!.uid == userUid) {
              isFollowButtonEnabled = false;
            } else {
              isFollowButtonEnabled = true;
            }

            updateFollowButton() async {
              DocumentReference ref =
                  FirebaseFirestore.instance.collection("users").doc(user!.uid);
              ref.get(GetOptions(source: Source.serverAndCache)).then((value) {
                if (currentUserFollowing.contains(userUid)) {
                  followButtonText = "Unfollow";
                  followButtonIcon = Icons.person_add_disabled_outlined;
                } else {
                  followButtonText = "Follow";
                  followButtonIcon = Icons.person_add_alt;
                }
              });
            }

            updateFollowButton();

            userName = userData.docs[userIndex]["userName"];
            userDescription = userData.docs[userIndex]["description"];
            userPhotoUrl = userData.docs[userIndex]["photoUrl"];
            userCreatedPost = userData.docs[userIndex]["createdPost"];
            usersFollowers = userData.docs[userIndex]["followers"];
            usersFollwings = userData.docs[userIndex]["followings"];

            Future<void> follow(userToFollow) async {
              // print(currentUserFollowing);
              DocumentReference ref =
                  FirebaseFirestore.instance.collection("users").doc(userUid);
              if (currentUserFollowing.contains(userToFollow) == true) {
                currentUserFollowing.remove(userToFollow);
                usersFollowers.remove(user!.uid);
                print(currentUserFollowing);
                // followButtonText = "Unfollow";
                // followButtonIcon = Icons.person_add_disabled_outlined;

                await ref.update({"followers": usersFollowers});
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid);

                await userRef.update({"followings": currentUserFollowing});
              }
              if (currentUserData.docs[currentUserIndex]["followings"]
                      .contains(userToFollow) ==
                  false) {
                currentUserFollowing.add(userToFollow);
                usersFollowers.add(user!.uid);
                await ref.update(
                    {"followers": FieldValue.arrayUnion(usersFollowers)});
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid);

                await userRef.update({
                  "followings": FieldValue.arrayUnion(currentUserFollowing)
                });
              }
            }

            // FollowersFollowings Function
            AlertDialog FollowersFollowings(String typeToShow, snapshots) {
              List data;
              if (typeToShow == "Followers") {
                data = usersFollowers;
              } else {
                data = usersFollwings;
              }

              return AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                content: Container(
                  padding: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: SingleChildScrollView(
                    child: Container(
                      width: 350,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          String? photoUrl;
                          String? userName;
                          // String? userUid;
                          String? userDescription;
                          String? thisUserUid;
                          final userData = snapshot.requireData;
                          String? followButtonText;
                          IconData followButtonIcon;
                          int indexOfTheUser = 0;
                          int k = 0;

                          for (var i in userData.docs) {
                            if (data[index] == userData.docs[k].reference.id) {
                              indexOfTheUser = k;
                            }
                            k += 1;
                          }
                          if (currentUserFollowing.contains(data[index]) ==
                              true) {
                            followButtonText = "Unfollow";
                            followButtonIcon =
                                Icons.person_add_disabled_outlined;
                          } else {
                            followButtonText = "Follow";
                            followButtonIcon = Icons.person_add_alt;
                          }
                          photoUrl = userData.docs[indexOfTheUser]["photoUrl"];
                          userName = userData.docs[indexOfTheUser]["userName"];
                          userDescription =
                              userData.docs[indexOfTheUser]["description"];
                          thisUserUid = userData.docs[indexOfTheUser].id;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                // width: 400,
                                // height: 90,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => usersProfile(
                                                thisUserUid, context)));
                                  },
                                  minVerticalPadding: 0,
                                  title: Text(
                                    userName!,
                                    style: TextStyle(
                                        fontFamily: "VareLaRound",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        Image.network(photoUrl!).image,
                                    radius: 20.0,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                        itemCount: data.length,
                      ),
                    ),
                  ),
                ),
              );
            }

            usersCreatedPosts(List createdPosts) {
              final Stream<QuerySnapshot> postRef =
                  FirebaseFirestore.instance.collection("posts").snapshots();
              return StreamBuilder<QuerySnapshot>(
                stream: postRef,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Loading(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Loading(),
                    );
                  }
                  DocumentReference ref = FirebaseFirestore.instance
                      .collection("users")
                      .doc(user!.uid);
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: createdPosts.length,
                    itemBuilder: ((context, int currentPost) {
                      //   QueryDocumentSnapshot<Object?> currentDocs =
                      // dataOfPosts.docs[index];
                      final dataOfPosts = snapshot.requireData;
                      int postIndex = 0;
                      int k = 0;
                      for (var i in dataOfPosts.docs) {
                        if (createdPosts[currentPost] ==
                            dataOfPosts.docs[k].id) {
                          postIndex = k;
                        }
                        k += 1;
                      }
                      String? postUsersPhotoURL =
                          dataOfPosts.docs[postIndex]["userProfilePicUrl"];
                      String? postUserDisplayName =
                          dataOfPosts.docs[postIndex]["userName"];
                      String? postUsersUid =
                          dataOfPosts.docs[postIndex]["userUID"];
                      String? postContent =
                          dataOfPosts.docs[postIndex]["content"];
                      String? postPhotoURL =
                          dataOfPosts.docs[postIndex]["photoUrl"];
                      List postUsersThatLikedIt =
                          dataOfPosts.docs[postIndex]['likedBy'];
                      int? postLikes = dataOfPosts.docs[postIndex]["likes"];
                      List savedPost = [];
                      int postHour = dataOfPosts.docs[postIndex]['hour'];
                      int postYear = dataOfPosts.docs[postIndex]["year"];
                      int postMonth = dataOfPosts.docs[postIndex]["month"];
                      int postDay = dataOfPosts.docs[postIndex]["day"];
                      // String postTime =
                      //     Jiffy(DateTime(postYear, postMonth, postDay)).fromNow();
                      String postTime = Jiffy({
                        "year": postYear,
                        "day": postDay,
                        "month": postMonth,
                        "hour": postHour
                      }).fromNow();
                      Widget postHeartWidget;
                      bool isPostAlreadySaved = false;
                      ref.get().then((value) {
                        for (var i in value["savedPost"]) {
                          savedPost.add(i);
                          if (dataOfPosts.docs[postIndex].id == i) {
                            isPostAlreadySaved = true;
                          } else {
                            isPostAlreadySaved == false;
                          }
                        }
                      });
                      if (postUsersThatLikedIt.contains(user!.uid)) {
                        postHeartWidget = const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 35,
                        );
                      } else {
                        postHeartWidget = const Icon(
                          Icons.favorite_border_sharp,
                          size: 35,
                        );
                      }
                      return Container(
                        child: Card(
                          elevation: 7,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => usersProfile(
                                                postUsersUid!, context))));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        Image.network(postUsersPhotoURL!).image,
                                    radius: 20.0,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        side: BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                content: Column(
                                                  children: [
                                                    Card(
                                                      shape: const RoundedRectangleBorder(
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
                                                                      Icons
                                                                          .done,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 20,
                                                                    )
                                                                  : const Text(
                                                                      ""),
                                                          leading: const Icon(
                                                            Icons.add_to_photos,
                                                            size: 25,
                                                          ),
                                                          title: const Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "VareLaRound",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                // color: Colors.black
                                                              )),
                                                          onTap: () {
                                                            addPostToFavorite(
                                                                dataOfPosts
                                                                    .docs[
                                                                        postIndex]
                                                                    .id,
                                                                isPostAlreadySaved);
                                                            Navigator.pop(
                                                                context);
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
                                    "$postUserDisplayName\n • $postTime",
                                    style: const TextStyle(
                                        fontFamily: "VareLaRound",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                const Divider(),
                                Container(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ReadMoreText(
                                      postContent!,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontFamily: "VareLaRound",
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  // child: Image.network(postPhotoURL!)
                                  child: Image.network(
                                    postPhotoURL!,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Divider(),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (postUsersThatLikedIt
                                                .contains(user!.uid)) {
                                              DocumentReference<
                                                      Map<String, dynamic>>
                                                  ref = FirebaseFirestore
                                                      .instance
                                                      .collection("posts")
                                                      .doc(dataOfPosts
                                                          .docs[postIndex].id);
                                              postUsersThatLikedIt
                                                  .remove(user!.uid);
                                              ref.update({
                                                "likedBy": postUsersThatLikedIt,
                                                "likes": postLikes! - 1
                                              });
                                            } else {
                                              DocumentReference<
                                                      Map<String, dynamic>>
                                                  ref = FirebaseFirestore
                                                      .instance
                                                      .collection("posts")
                                                      .doc(dataOfPosts
                                                          .docs[postIndex].id);
                                              postUsersThatLikedIt
                                                  .add(user!.uid);
                                              ref.update({
                                                "likedBy":
                                                    FieldValue.arrayUnion(
                                                        postUsersThatLikedIt),
                                                "likes": postLikes! + 1
                                              });
                                            }
                                          },
                                          icon: postHeartWidget,
                                        ),
                                        Text(Numeral(postLikes!).toString(),
                                            style: const TextStyle(
                                              fontFamily: "VareLaRound",
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              );
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          backgroundImage: Image.network(userPhotoUrl!).image,
                          radius: 50.0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName!,
                            style: TextStyle(
                                fontFamily: "VareLaRound",
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          isFollowButtonEnabled
                              ? ElevatedButton(
                                  autofocus: true,
                                  clipBehavior: Clip.antiAlias,
                                  onPressed: () {
                                    follow(userData.docs[userIndex].id);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        followButtonText!,
                                        style: TextStyle(
                                          fontFamily: "VareLaRound",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Icon(followButtonIcon),
                                    ],
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                child: Text(
                                  "• Followers: ",
                                  style: TextStyle(
                                      fontFamily: "VareLaRound",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => FollowersFollowings(
                                          "Followers", snapshot));
                                },
                              ),
                              Text(
                                Numeral(usersFollowers.length).format(),
                                style: TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                style: ButtonStyle(),
                                child: Text(
                                  "• Followings: ",
                                  style: TextStyle(
                                      fontFamily: "VareLaRound",
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => FollowersFollowings(
                                          "Followings", snapshot));
                                },
                              ),
                              Text(
                                Numeral(usersFollwings.length).format(),
                                style: TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ReadMoreText(
                        userDescription!,
                        style: TextStyle(
                            leadingDistribution: TextLeadingDistribution.even,
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.w300),
                      ),
                      Divider(),
                      Text(
                        "Created Posts",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      usersCreatedPosts(userCreatedPost)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
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

  postTheInfo(String text, String photoUrl) async {
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection("posts").doc();
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
    });
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);
    userRef.get().then((userPost) {
      List allTheCurrentUserPosts = userPost['createdPost'];
      allTheCurrentUserPosts.add(ref.id);
      userRef.update(
          {'createdPost': FieldValue.arrayUnion(allTheCurrentUserPosts)});
    });

    Fluttertoast.showToast(msg: "");
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
