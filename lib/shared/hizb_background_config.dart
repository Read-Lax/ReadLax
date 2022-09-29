import 'package:flutter_background/flutter_background.dart';
import 'package:readlex/shared/global.dart';

FlutterBackgroundAndroidConfig backgroundConfig (int hizbIndex) => FlutterBackgroundAndroidConfig(
    notificationTitle: "ReadLax",
    notificationText: "Dowloading ${hizbTitle(hizbIndex).toString()}",
    notificationImportance: AndroidNotificationImportance.High,
    // notificationIcon: const AndroidResource(name: 'background_icon', defType: 'drawwable'), // Default is ic_launcher from folder mipmap
); 

