import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:readlex/shared/global.dart';

Future<bool> isThereANewUpdate() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  bool isToUpdate = false;
  String appVersion = remoteConfig.getString("app_version").toString();
  if (appVersion == currentAppVersion) {
    isToUpdate = false;
  } else {
    isToUpdate = true;
  }
  return isToUpdate;
}
