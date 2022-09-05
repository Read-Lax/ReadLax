import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';
import 'package:readlex/Widgets/posts.dart';

class SavedPost {
  savedPostsPage(usersSnapshot) {
    final Stream<QuerySnapshot> firestorePostData =
        FirebaseFirestore.instance.collection("posts").snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: firestorePostData,
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
          final dataOfPosts = snapshot.requireData;
          List savedPost = usersSnapshot;
          int k = 0;
          List? cardToDisplay = [];
          bool isThereAnySavedPost;
          // get the index of the posts nad saved in side a list
          // so we can make a ListVeiw.builder that has itemCount : cardToDiplay.length
          for (var i in savedPost) {
            if (i == dataOfPosts.docs[k].reference.id) {
              cardToDisplay.add(showPost(dataOfPosts.docs[k], context));
            }
            k += 1;
          }
          if (cardToDisplay.isNotEmpty == true) {
            isThereAnySavedPost = true;
          } else {
            isThereAnySavedPost = false;
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                color: Theme.of(context).primaryColor,
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
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
            body: isThereAnySavedPost
                ? ListView.builder(
                    itemCount: cardToDisplay.length,
                    itemBuilder: ((context, index) {
                      return cardToDisplay[index];
                    }),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          "It seems like you don't have any saved posts yet",
                          style: TextStyle(
                            fontFamily: "VareLaRound",
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
