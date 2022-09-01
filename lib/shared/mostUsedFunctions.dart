import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:numeral/numeral.dart';
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

User? user = FirebaseAuth.instance.currentUser;

usersProfile(userUid, context) {
  final Stream<QuerySnapshot> userRef =
      FirebaseFirestore.instance.collection("users").snapshots();
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  var userData;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        color: Theme.of(context).primaryColor,
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: StreamBuilder<QuerySnapshot>(
        stream: userRef,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Loading(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Loading(),
            );
          }
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
            ref
                .get(const GetOptions(source: Source.serverAndCache))
                .then((value) {
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

          String? userName = userData.docs[userIndex]["userName"];
          String? userDescription = userData.docs[userIndex]["description"];
          String? userPhotoUrl = userData.docs[userIndex]["photoUrl"];
          List userCreatedPost = userData.docs[userIndex]["createdPost"];
          List usersFollowers = userData.docs[userIndex]["followers"];
          List usersFollwings = userData.docs[userIndex]["followings"];

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
              DocumentReference userRef =
                  FirebaseFirestore.instance.collection("users").doc(user!.uid);

              await userRef.update({"followings": currentUserFollowing});
            }
            if (currentUserData.docs[currentUserIndex]["followings"]
                    .contains(userToFollow) ==
                false) {
              currentUserFollowing.add(userToFollow);
              usersFollowers.add(user!.uid);
              await ref
                  .update({"followers": FieldValue.arrayUnion(usersFollowers)});
              DocumentReference userRef =
                  FirebaseFirestore.instance.collection("users").doc(user!.uid);

              await userRef.update(
                  {"followings": FieldValue.arrayUnion(currentUserFollowing)});
            }
          }

          // FollowersFollowings Function
          AlertDialog FollowersFollowings(String typeToShow, snapshots) {
            List data;
            String? ifDataIsEmptyMsg;
            if (typeToShow == "Followers") {
              data = usersFollowers;
              ifDataIsEmptyMsg = userName == user!.displayName
                  ? "You don't have any followers"
                  : "$userName doesn't have any followers";
            } else {
              data = usersFollwings;
              ifDataIsEmptyMsg = userName == user!.displayName
                  ? "You don't seem to be following any one"
                  : "$userName doesn't seems to be following any one";
            }

            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              content: Container(
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width * 0.45,
                child: SingleChildScrollView(
                  child: Container(
                      width: 350,
                      child: data.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                String? photoUrl;
                                String? userName;
                                // String? userUid;
                                // String? userDescription;
                                String? thisUserUid;
                                final userData = snapshot.requireData;
                                String? followButtonText;
                                IconData followButtonIcon;
                                int indexOfTheUser = 0;
                                int k = 0;

                                for (var i in userData.docs) {
                                  if (data[index] ==
                                      userData.docs[k].reference.id) {
                                    indexOfTheUser = k;
                                  }
                                  k += 1;
                                }
                                if (currentUserFollowing
                                        .contains(data[index]) ==
                                    true) {
                                  followButtonText = "Unfollow";
                                  followButtonIcon =
                                      Icons.person_add_disabled_outlined;
                                } else {
                                  followButtonText = "Follow";
                                  followButtonIcon = Icons.person_add_alt;
                                }
                                photoUrl =
                                    userData.docs[indexOfTheUser]["photoUrl"];
                                userName =
                                    userData.docs[indexOfTheUser]["userName"];
                                userDescription = userData.docs[indexOfTheUser]
                                    ["description"];
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
                                                builder: (context) =>
                                                    usersProfile(
                                                        thisUserUid, context)));
                                      },
                                      minVerticalPadding: 0,
                                      title: Text(
                                        userName!,
                                        style: const TextStyle(
                                            fontFamily: "VareLaRound",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            Image.network(photoUrl!).image,
                                        radius: 20.0,
                                      ),
                                    )),
                                  ],
                                );
                              }),
                              itemCount: data.length,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.question_mark_rounded,
                                  // size: 30,
                                ),
                                title: Text(
                                  ifDataIsEmptyMsg,
                                  style: const TextStyle(
                                    fontFamily: "VareLaRound",
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 17,
                                  ),
                                ),
                              ),
                            )),
                ),
              ),
              actions: [
                ifDataIsEmptyMsg.isNotEmpty
                    ? CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                    : const Text("")
              ],
            );
          }

          usersCreatedPosts(List createdPosts) {
            final Stream<QuerySnapshot> postRef =
                FirebaseFirestore.instance.collection("posts").snapshots();
            return StreamBuilder<QuerySnapshot>(
              stream: postRef,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Loading(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Loading(),
                  );
                }
                DocumentReference ref = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid);
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: createdPosts.length,
                  itemBuilder: ((context, int currentPost) {
                    //   QueryDocumentSnapshot<Object?> currentDocs =
                    // dataOfPosts.docs[index];
                    final dataOfPosts = snapshot.requireData;
                    int postIndex = 0;
                    int k = 0;
                    for (var i in dataOfPosts.docs) {
                      if (createdPosts[currentPost] == dataOfPosts.docs[k].id) {
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
                    return showPost(dataOfPosts.docs[postIndex], context);
                  }),
                );
              },
            );
          }

          String non = "";
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName!,
                            style: const TextStyle(
                                fontFamily: "VareLaRound",
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: isFollowButtonEnabled ? 30 : 0,
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
                                        style: const TextStyle(
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
                              : Column()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                child: const Text(
                                  "• Followers: ",
                                  style: const TextStyle(
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
                                style: const TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                style: const ButtonStyle(),
                                child: const Text(
                                  "• Followings: ",
                                  style: const TextStyle(
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
                                style: const TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: ReadMoreText(
                            userDescription!,
                            textDirection: isRTL(userDescription!)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                fontFamily: "VareLaRound",
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Text(
                        "Created Posts",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                          child: userCreatedPost.isNotEmpty
                              ? usersCreatedPosts(userCreatedPost)
                              : Center(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        Text(
                                          userName == user!.displayName
                                              ? "You have not created any posts yet"
                                              : "$userName has not created any posts yet",
                                          style: const TextStyle(
                                            fontFamily: "VareLaRound",
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
  );
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

showPost(snapshotData, context) {
  String? postUsersPhotoURL = snapshotData["userProfilePicUrl"];
  String? postUserDisplayName = snapshotData["userName"];
  String? postUsersUid = snapshotData["userUID"];
  String? postContent = snapshotData["content"];
  String? postPhotoURL = snapshotData["photoUrl"];
  String? postUID = snapshotData!.id;
  String? postImageNameInTheStorage = snapshotData["imageName"];
  List postUsersThatLikedIt = snapshotData["likedBy"];
  List postUsersThatSavedIt = snapshotData["savedBy"];
  int? postLikes = snapshotData["likes"];
  List savedPost = [];
  int postHour = snapshotData['hour'];
  int postYear = snapshotData["year"];
  int postMonth = snapshotData["month"];
  int postDay = snapshotData["day"];
  String postTime = Jiffy({
    "year": postYear,
    "day": postDay,
    "month": postMonth,
    "hour": postHour
  }).fromNow();
  Widget postHeartWidget;
  bool isPostAlreadySaved = false;
  bool isDeleteButtonEnabled;
  DocumentReference ref =
      FirebaseFirestore.instance.collection("users").doc(user!.uid);
  double alertDialogHeight;
  Report report = Report();
  // checking wether the post is saved by the current user
  // or not

  ref.get().then((value) {
    for (var i in value["savedPost"]) {
      savedPost.add(i);
      if (snapshotData.id == i) {
        isPostAlreadySaved = true;
      } else {
        isPostAlreadySaved == false;
      }
    }
  });
  if (user!.uid == postUsersUid) {
    isDeleteButtonEnabled = true;
  } else {
    isDeleteButtonEnabled = false;
  }
  // checking wether the post is liked by the current user
  // or not
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
  if (isDeleteButtonEnabled) {
    alertDialogHeight = 190;
  } else {
    alertDialogHeight = 70;
  }
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  return Container(
    child: Card(
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
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
                  backgroundImage: Image.network(postUsersPhotoURL!).image,
                  radius: 20.0,
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => Container(
                              height: alertDialogHeight,
                              width: double.infinity,
                              child: AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                content: Container(
                                  height: alertDialogHeight,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
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
                                                  fontFamily: "VareLaRound",
                                                  fontWeight: FontWeight.bold,
                                                  // color: Colors.black
                                                )),
                                            onTap: () {
                                              addPostToFavorite(snapshotData.id,
                                                  postUsersThatSavedIt);
                                              Navigator.pop(context);
                                              // Fluttertoast.showToast(
                                              //     msg:
                                              //         "Post have been saved successfully");
                                            }),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.report_gmailerrorred_outlined,
                                          size: 25,
                                        ),
                                        title: const Text(
                                          "Report",
                                          style: const TextStyle(
                                            fontFamily: "VareLaRound",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          report.reportPost(
                                              postUsersUid, postUID);
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Thank you for your FeedBack.");
                                        },
                                      ),
                                      isDeleteButtonEnabled
                                          ? Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                              elevation: 0,
                                              child: ListTile(
                                                  leading: const Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    color: Colors.redAccent,
                                                    size: 25,
                                                  ),
                                                  title: const Text("Delete",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "VareLaRound",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.redAccent
                                                          // color: Colors.black
                                                          )),
                                                  onTap: () {
                                                    deleteAPost(
                                                        postUID,
                                                        postUsersThatSavedIt,
                                                        postUsersUid,
                                                        postImageNameInTheStorage);
                                                    Navigator.pop(context);
                                                    // Fluttertoast.showToast(
                                                    //     msg:
                                                    //         "Post have been saved successfully");
                                                  }),
                                            )
                                          : const Text(""),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                ),
                title: Text(
                  postUserDisplayName!,
                  style: const TextStyle(
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  "• $postTime",
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "VareLaRound",
                  ),
                )),
            const Divider(),
            Container(
              child: Directionality(
                textDirection:
                    isRTL(postContent!) ? TextDirection.rtl : TextDirection.ltr,
                child: ReadMoreText(
                  postContent,
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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Image.network(
                postPhotoURL!,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
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
                        if (postUsersThatLikedIt.contains(user!.uid)) {
                          DocumentReference<Map<String, dynamic>> ref =
                              FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(snapshotData.id);
                          postUsersThatLikedIt.remove(user!.uid);
                          ref.update({
                            "likedBy": postUsersThatLikedIt,
                            "likes": postLikes! - 1
                          });
                        } else {
                          DocumentReference<Map<String, dynamic>> ref =
                              FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(snapshotData.id);
                          postUsersThatLikedIt.add(user!.uid);
                          ref.update({
                            "likedBy":
                                FieldValue.arrayUnion(postUsersThatLikedIt),
                            "likes": postLikes! + 1
                          });
                        }
                      },
                      icon: postHeartWidget,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(Numeral(postLikes!).toString(),
                            style: const TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text(
                          "likes",
                          style: TextStyle(
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ComentsPage(
                                        postId: postUID,
                                      ))));
                        },
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                          // color: Colors.teal,
                          size: 37,
                        )),
                    const Text("")
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
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
