import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
import 'package:readlex/Widgets/post_card.dart';
import 'package:readlex/shared/global.dart';
import 'package:readmore/readmore.dart';

usersProfile(userUid, context) {
  final Stream<QuerySnapshot> userRef =
      FirebaseFirestore.instance.collection("users").snapshots();

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
            return const LoadingCircule();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingCircule();
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
                              itemBuilder: ((context, index) {
                                String? photoUrl;
                                String? userName;
                                String? thisUserUid;
                                final userData = snapshot.requireData;
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
                  return const LoadingCircule();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingCircule();
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
                    List postUsersThatLikedIt =
                        dataOfPosts.docs[postIndex]['likedBy'];
                    List savedPost = [];
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
                        padding: const EdgeInsets.all(11.0),
                        child: ReadMoreText(
                          userDescription!,
                          textDirection: isRTL(userDescription!)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: const TextStyle(
                              leadingDistribution: TextLeadingDistribution.even,
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      const Divider(),
                      Text(
                        "Created Posts",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                          child: userCreatedPost.isNotEmpty
                              ? usersCreatedPosts(userCreatedPost)
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          // fontWeight: FontWeight.bold,
                                          // fontSize: 17,
                                        ),
                                      ),
                                    ],
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
