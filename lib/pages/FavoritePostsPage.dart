import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';

class SavedPost {
  savedPosrPage(usersSnapshot) {
    final Stream<QuerySnapshot> firestorePostData =
        FirebaseFirestore.instance.collection("posts").snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: firestorePostData,
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
          final dataOfPosts = snapshot.requireData;
          List savedPost = usersSnapshot;
          int k = 0;
          List? cardToDisplay = [];
          // get the index of the posts nad saved in side a list 
          // so we can make a ListVeiw.builder that has itemCount : cardToDiplay.length
          for (var i in savedPost) {
            if (i == dataOfPosts.docs[k].reference.id) {
              cardToDisplay.add(showPost(dataOfPosts.docs[k], context));
            }
            k += 1;
          }
          
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Saved Posts",
                  style: TextStyle(
                      fontFamily: "VareLaRound",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.greenAccent),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: ListView.builder(
                itemCount: cardToDisplay.length,
                itemBuilder: ((context, index) {
                  return cardToDisplay[index];
                }),
              ));
        });
  }
}
