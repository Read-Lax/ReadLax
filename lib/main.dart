// ReadLax, read Quran and stay relaxed
// devloped by ramsy, 0RaMsY0
// github: https://github.com/Read-Lax/ReadLax
// app idea by the devloper(ramsy)'s mother

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// screens
import 'package:readlex/screens/explore/explore.dart';
import 'package:readlex/screens/home/home.dart';
import 'package:readlex/screens/read_quran/read_quran.dart';
import 'package:readlex/screens/user_profile/user_profile.dart';
import 'package:readlex/utils/app_permissions/storage_permission.dart';
import 'screens/login/login_screen.dart';
import 'package:readlex/screens/settings/setting.dart';
import 'package:readlex/screens/splash_screen/splash_screen.dart';
import 'package:readlex/providers/theme_provider/theme_provider.dart';
import 'package:readlex/screens/create_new_post/create_new_post.dart';
import 'package:readlex/screens/saved_posts/saved_posts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  // record crashes and repost into firebase crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // hive db
  await Hive.openBox("hizbData");
  await Hive.openBox("backgroundProcess");
  // await Hive.openBox("settings");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'ReadLax',
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const ShowPage(),
          );
        });
  }
}

class ShowPage extends StatelessWidget {
  const ShowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SplashScreen(whatToReturn: const HomePage());
          } else {
            return const LoginPage();
          }
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String userId = "";
  late double longtitude = 0.0;
  late double laltitude = 0.0;
  final List _appBarTitle = [
    "Home",
    "Read Quran",
    "Explore",
    "",
  ];

  int _appBarTitleIndex = 0;
  final List _scaffoldBodyContent = [
    HomePageContent(),
    const ReadQuranPage(),
    const ExplorePage(),
    //usersProfile(null, ext)
  ];
  final Stream<QuerySnapshot> firestoreUserData =
      FirebaseFirestore.instance.collection("users").snapshots();
  // check for location permession and getting the longtitude and laltitude
  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // Position? latestPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      laltitude = position.latitude;
      longtitude = position.longitude;
    });
  }

  @override
  void initState() {
    // permissions
    _getUserLocation();
    askForPermision();
    _scaffoldBodyContent.add(
      usersProfile(null, context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = _scaffoldBodyContent[_appBarTitleIndex];
    return Stack(
      fit: StackFit.expand, 
      children: [
      StreamBuilder<QuerySnapshot>(
          stream: firestoreUserData,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const LoadingCircule();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingCircule();
            }
            final data = snapshot.requireData;
            int userIndex = 0;
            int k = 0;
            for (var i in data.docs) {
              if (user!.uid == data.docs[k].reference.id) {
                userIndex = k;
              }
              k += 1;
            }
            String? userName = data.docs[userIndex]["userName"];
            String? userProfileUrl = data.docs[userIndex]["photoUrl"];
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: Theme.of(context).primaryIconTheme,
                title: Text(
                  _appBarTitle[_appBarTitleIndex],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: "VareLaRound",
                    letterSpacing: 2,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  _appBarTitleIndex == 2
                      ? IconButton(
                          splashRadius: 17.0,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const CreateNewPost()),
                              ),
                            );                          },
                          icon: Icon(
                            Icons.add,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ))
                      : const SizedBox(),
                  _appBarTitleIndex == 3 
                      ? Row(
                        children: [
                        IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPost().savedPostsPage(data.docs[userIndex]["savedPost"])));
                        }, 
                          icon: const Icon( 
                            Icons.add_to_photos_rounded
                        ),),
                        IconButton(
                          onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                        }, 
                          icon: const Icon(
                              Icons.settings
                      )),
                    ],
                  ) : const SizedBox(),
                ],
              ),
              bottomNavigationBar : SalomonBottomBar(
                currentIndex: _appBarTitleIndex,
                onTap: (newValue) => setState(() => _appBarTitleIndex = newValue),
                items: [
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.home),
                      title: const Text("Home"),
                      selectedColor: Colors.greenAccent,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.chrome_reader_mode_rounded),
                      title: const Text("Read Quran"),
                      selectedColor: Colors.greenAccent,
                    ),
                     SalomonBottomBarItem(
                      icon: const Icon(Icons.search),
                      title: const Text("Explore"),
                      selectedColor: Colors.greenAccent,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.account_circle),
                      title: const Text("Profile"),
                      selectedColor: Colors.greenAccent,
                    ),
                ]),  
              body: _appBarTitleIndex == 0
                  ? HomePageContent(
                      lat: laltitude,
                      long: longtitude,
                    )
                  : scaffoldBody,
                );
          }),
    ]);
  }
}
