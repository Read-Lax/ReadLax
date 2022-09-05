import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readlex/shared/global.dart';

isThereANewUpdate() async {
  String newUpdateVersion = FirebaseFirestore.instance
      .collection("app_details")
      .doc("app_version")
      .toString();
  if (newUpdateVersion != currentAppVersion) {
    return null;
  } else {
    return true;
  }
}

Future<String> newUpdateName() async {
  var document = FirebaseFirestore.instance.collection("app_details");
  var docSnapshot = await document.doc("wpkYMe7TGacpc2tudyCp").get();
  Map<String, dynamic>? data = docSnapshot.data();
  // Future<String> newVersion = data?["app_version"];
  return data?["app_version"];
}

Future<String> newUpdateDownloadUrl() async {
  var document = FirebaseFirestore.instance.collection("app_details");
  var docSnapshot = await document.doc("wpkYMe7TGacpc2tudyCp").get();
  Map<String, dynamic>? data = docSnapshot.data();
  return data?["download_url"];
}

newUpdateFeaturs() async {
  var document = FirebaseFirestore.instance.collection("app_details");
  var docSnapshot = await document.doc("wpkYMe7TGacpc2tudyCp").get();
  Map<String, dynamic>? data = docSnapshot.data();
  print(data?["features"]);
  return data?["features"];
}

Future<List> newUpdateFixedBugs() async {
  var document = FirebaseFirestore.instance.collection("app_details");
  var docSnapshot = await document.doc("wpkYMe7TGacpc2tudyCp").get();
  Map<String, dynamic>? data = docSnapshot.data();
  return data?["fixes"];
}
