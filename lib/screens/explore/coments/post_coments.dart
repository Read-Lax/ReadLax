import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
import 'package:readlex/screens/explore/functions/publish_coment.dart';
import 'package:readlex/screens/user_profile/user_profile.dart';
import 'package:readlex/screens/explore/functions/delete_coment.dart';
import 'package:readlex/shared/report_content.dart';

class ComentsPage extends StatefulWidget {
  ComentsPage({Key? key, required this.postId}) : super(key: key);
  String? postId;
  @override
  State<ComentsPage> createState() => _ComentsPageState();
}

class _ComentsPageState extends State<ComentsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Report report = Report();
  TextEditingController userComent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
          color: Theme.of(context).primaryColor,
        ),
        title: const Text(
          'Coments',
          style: TextStyle(
            fontFamily: "VareLaRound",
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postId)
              .collection("coments")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const LoadingCircule();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingCircule();
            }
            final data = snapshot.requireData;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: Image.network(user!.photoURL!).image,
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: AutoDirection(
                          text: userComent.text.trim(),
                          child: TextField(
                            controller: userComent,
                            maxLength: 1000,
                            maxLines: null,
                            autofocus: false,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Leave a coment",
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (userComent.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "There is nothing to publish, the coment seems to be empty");
                                } else {
                                  uploadAComent(widget.postId,
                                      userComent.text.trim(), user!.uid);
                                  userComent.text = "";
                                }
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.greenAccent,
                              ))
                        ],
                      ),
                      const Divider(
                        thickness: 3,
                      ),
                      // TextField()
                    ],
                  ),
                  data.docs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final currentComentData =
                                snapshot.requireData.docs[index];
                            String? commentUserName =
                                currentComentData["userName"];
                            String? commentText =
                                currentComentData["comentContent"];
                            String? commentUserPhotoUrl =
                                currentComentData["userPhotoUrl"];
                            String? commentUserId =
                                currentComentData["comentUserUID"];
                            String comentTime = Jiffy({
                              "year": currentComentData["year"],
                              "day": currentComentData["day"],
                              "month": currentComentData["month"],
                              "hour": currentComentData["hour"]
                            }).fromNow();
                            List comentUsersLikes =
                                currentComentData["likedBy"];
                            String? currentComentUID = currentComentData.id;
                            bool isDeleteComent = user!.uid == commentUserId;

                            StatelessWidget comentLikeButton =
                                comentUsersLikes.contains(user!.uid)
                                    ? const Icon(
                                        Icons.thumb_up_alt_rounded,
                                        color: Colors.redAccent,
                                      )
                                    : const Icon(Icons.thumb_up_alt_outlined
                                        // color: Colors.redAccent,
                                        );
                            return Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage: Image.network(
                                            commentUserPhotoUrl!,
                                          ).image,
                                        ),
                                        title: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: "$commentUserName ",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontFamily: "VareLaRound",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            TextSpan(
                                                text: commentText,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: "VareLaRound",
                                                ))
                                          ]),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                              "• $comentTime",
                                              // textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontFamily: "VareLaRound",
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      usersProfile(
                                                          commentUserId,
                                                          context)));
                                        },
                                        trailing: IconButton(
                                          icon:
                                              const Icon(Icons.more_vert_sharp),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content: Container(
                                                        width: double.infinity,
                                                        height: isDeleteComent
                                                            ? 120
                                                            : 50,
                                                        child: Column(
                                                          children: [
                                                            isDeleteComent
                                                                ? ListTile(
                                                                    onTap: () {
                                                                      deleteAComent(
                                                                          currentComentUID,
                                                                          widget
                                                                              .postId,
                                                                          commentUserId);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    leading:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                      color: Colors
                                                                          .redAccent,
                                                                    ),
                                                                    title:
                                                                        const Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "VareLaRound",
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.redAccent),
                                                                    ),
                                                                  )
                                                                : const SizedBox(
                                                                    height: 1,
                                                                  ),
                                                            ListTile(
                                                              leading: const Icon(
                                                                  Icons
                                                                      .report_gmailerrorred_outlined),
                                                              title: const Text(
                                                                "Report",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "VareLaRound",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                report.reportComents(
                                                                    commentUserId,
                                                                    currentComentUID);
                                                                Navigator.pop(
                                                                    context);
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Thank you for your feedback.");
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          },
                                        ),
                                      ),
                                      // Text(commentText),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              comentUsersLikes
                                                      .contains(user!.uid)
                                                  ? comentUsersLikes
                                                      .remove(user!.uid)
                                                  : comentUsersLikes
                                                      .add(user!.uid);
                                              await FirebaseFirestore.instance
                                                  .collection("posts")
                                                  .doc(widget.postId)
                                                  .collection("coments")
                                                  .doc(currentComentUID)
                                                  .update({
                                                "likedBy": comentUsersLikes
                                              });
                                            },
                                            icon: comentLikeButton,
                                          ),
                                          Text(
                                            comentUsersLikes.length.toString(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            const Center(
                              child: Text(
                                "No coments yet, be the first one to comment!",
                                style: TextStyle(
                                  fontFamily: "VareLaRound",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          }),
    );
  }
}
