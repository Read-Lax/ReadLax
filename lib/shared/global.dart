import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as intl;
// app version
String currentAppVersion = "0.2-beta.7";

// access user data in firebase
User? user = FirebaseAuth.instance.currentUser;

// is the text from ltr or rtl
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }