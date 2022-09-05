import 'package:cloud_firestore/cloud_firestore.dart';

deleteAComent(String? comentUID, String? postUID,
    String? userUIDwhoCreatedTheComent) async {
  DocumentReference comentRef = FirebaseFirestore.instance
      .collection("posts")
      .doc(postUID)
      .collection("coments")
      .doc(comentUID);

  await comentRef.delete();
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userUIDwhoCreatedTheComent)
      .update({
    "comentedComents": FieldValue.arrayRemove([
      {"comentUID": comentUID, "postUID": postUID}
    ])
  });
}