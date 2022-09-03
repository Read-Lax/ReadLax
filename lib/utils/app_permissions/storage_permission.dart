import 'package:permission_handler/permission_handler.dart';


void askForPermision() async {
  PermissionStatus storage = await Permission.storage.request();
  if (storage == PermissionStatus.granted) {
  } else {
    print("no");
  }
}