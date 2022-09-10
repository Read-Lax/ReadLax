import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:numeral/numeral.dart';
import 'package:readlex/screens/explore/coments/post_coments.dart';
import 'package:readlex/screens/explore/functions/delete_post.dart';
import 'package:readlex/screens/explore/functions/save_post.dart';
import 'package:readlex/screens/user_profile/user_profile.dart';
import 'package:readlex/shared/global.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart' as intl;

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

  return Card(
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
                      builder: (_) => SizedBox(
                            height: alertDialogHeight,
                            width: double.infinity,
                            child: AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              content: SizedBox(
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
                                            savePost(snapshotData.id,
                                                postUsersThatSavedIt);
                                            Navigator.pop(context);
                                          }),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.report_gmailerrorred_outlined,
                                        size: 25,
                                      ),
                                      title: const Text(
                                        "Report",
                                        style: TextStyle(
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
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            elevation: 0,
                                            child: ListTile(
                                                leading: const Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: Colors.redAccent,
                                                  size: 25,
                                                ),
                                                title: const Text("Delete",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "VareLaRound",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.redAccent
                                                        // color: Colors.black
                                                        )),
                                                onTap: () {
                                                  deleteAPost(
                                                    postUID,
                                                    postUsersThatSavedIt,
                                                    postUsersUid,
                                                    postImageNameInTheStorage,
                                                  );
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
          Directionality(
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
          const SizedBox(
            height: 7,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            child: CachedNetworkImage(
              imageUrl: postPhotoURL!,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Column(
                children: [
                  CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
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
  );
}
