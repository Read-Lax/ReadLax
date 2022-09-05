import 'package:firebase_auth/firebase_auth.dart';

// app version
String currentAppVersion = "0.2-beta.7";

// access user data in firebase
User? user = FirebaseAuth.instance.currentUser;