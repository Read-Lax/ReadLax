import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:readlex/fireStoreHandeler/handeler.dart';

class ComentsPage extends StatefulWidget {
  var postId;
  ComentsPage({Key? key, required String? this.postId});
  // var postId;
  @override
  State<ComentsPage> createState() => _ComentsPageState();
}

class _ComentsPageState extends State<ComentsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  // final Stream<QuerySnapshot<Map<String, dynamic>>> postComentsRef = FirebaseFirestore.instance.collection("posts").doc(postId).collection("coments").snapshots();
  TextEditingController userComent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
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
                return Center(
                  child: SpinKitCircle(
                    color: Colors.greenAccent,
                    size: 50.0,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    color: Colors.greenAccent,
                    size: 50.0,
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 7,
                      ),
                      CircleAvatar(
                        backgroundImage: Image.network(user!.photoURL!).image,
                      ),
                      SizedBox(
                        width: 11,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          // color: Colors.grey[200],
                        ),
                        child: TextField(
                          controller: userComent,
                          maxLength: 1000,
                          maxLines: null,
                          autofocus: false,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Leave a coment",
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
                                }
                              },
                              icon: Icon(
                                Icons.send_rounded,
                                color: Colors.greenAccent,
                              ))
                        ],
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      // TextField()
                    ],
                  ),
                  snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final currentComentData =
                                snapshot.requireData.docs[index];
                            // GetUserData getUserData = GetUserData();
                            String? commentUserName =
                                currentComentData["userName"];
                            String? commentText =
                                currentComentData["comentContent"];
                            String? commentUserPhotoUrl =
                                currentComentData["userPhotoUrl"];
                            String? commentUserId =
                                currentComentData["comentUserUID"];
                            String? currentComentUID = currentComentData.id;
                            bool isDeleteComent = user!.uid == commentUserId;

                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 20.0,
                                    child: Image.network(
                                      commentUserPhotoUrl!,
                                    ),
                                  ),
                                  title: Text(
                                    commentUserName!,
                                    style: TextStyle(
                                      fontFamily: "VareLaRound",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  // subtitle: AutoDirection(
                                  //   text: commentText!,
                                  //   child: Container(),
                                  // ),
                                  subtitle: Text(
                                    commentText!,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontFamily: "VareLaRound",
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.more_vert_sharp),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Container(
                                                  width: double.infinity,
                                                  height:
                                                      isDeleteComent ? 120 : 50,
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
                                                              leading: Icon(
                                                                Icons
                                                                    .delete_outline,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                              title: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "VareLaRound",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .redAccent),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      ListTile(
                                                        leading: Icon(Icons
                                                            .report_gmailerrorred_outlined),
                                                        title: Text(
                                                          "report",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "VareLaRound",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                  ),
                                ),
                                Divider(
                                    // thickness: 3,
                                    ),
                              ],
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Center(
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
              );
            }));
  }
}
