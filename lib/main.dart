// ReadLax, read Quran and stay relaxed
// devloped by ramsy, 0RaMsY0
// github: https://github.com/0RaMsY0/ReadLax
// idea by the devloper's mother

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
// imporintg pages contents
import 'package:readlex/screens/explore/explore.dart';
import 'package:readlex/screens/home/home.dart';
import 'package:readlex/screens/read_quran/read_quran.dart';
import 'package:readlex/screens/user_profile/user_profile.dart';
import 'package:readlex/utils/app_permissions/storage_permission.dart';
import 'screens/login/login_screen.dart';
import 'package:readlex/screens/settings/setting.dart';
import 'package:readlex/screens/splash_screen/splash_screen.dart';
import 'package:readlex/providers/theme_provider/theme_provider.dart';
import 'package:readlex/shared/global.dart';
import 'package:readlex/utils/create_new_post.dart';
import 'package:readlex/screens/saved_posts/saved_posts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Readlax',
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // theme: ThemeData(
            //   brightness: Brightness.dark,
            // ),
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
  late double longtitude = 0.0;
  late double laltitude = 0.0;
  final List _appBarTitle = [
    "Home",
    "Read Quran",
    "Explore",
  ];

  int _appBarTitleIndex = 0;
  final List _scaffoldBodyContent = [
    HomePageContent(),
    const ReadQuranPage(),
    const ExplorePage()
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
    _getUserLocation();
    askForPermision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = _scaffoldBodyContent[_appBarTitleIndex];
    return Stack(fit: StackFit.expand, children: [
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
                            showDialog(
                                context: context,
                                builder: (_) => createNewPost());
                          },
                          icon: Icon(
                            Icons.add,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ))
                      : const SizedBox(),
                ],
              ),
              bottomNavigationBar: NavigationBarTheme(
                data: NavigationBarThemeData(
                  // indicatorColor: Colors.teal,
                  labelTextStyle: MaterialStateProperty.all(const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "VareLaRound",
                    fontSize: 13,
                  )),
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  animationDuration: const Duration(seconds: 1),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  height: 53.3,
                  selectedIndex: _appBarTitleIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _appBarTitleIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(
                        Icons.home_filled,
                        color: Colors.greenAccent,
                      ),
                      label: "Home",
                      tooltip: "Home",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.chrome_reader_mode_rounded,
                          color: Colors.greenAccent),
                      label: "Read Quran",
                      tooltip: "Read Quran",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore_outlined,
                          color: Colors.greenAccent),
                      label: "Explore",
                      tooltip: "Explore",
                    )
                  ],
                ),
              ),
              body: _appBarTitleIndex == 0
                  ? HomePageContent(
                      lat: laltitude,
                      long: longtitude,
                    )
                  : scaffoldBody,
              drawer: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(userProfileUrl!),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            userName!,
                            // currentUserData.getUserName(user!.uid),
                            style: const TextStyle(
                              fontFamily: "VareLaRound",
                              fontSize: 20,
                              // color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.person_outline_outlined,
                          size: 25,
                        ),
                        title: const Text("Profile",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              // color: Colors.black
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      usersProfile(user!.uid, context)));
                        },
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ListTile(
                        leading: const Icon(
                          Icons.add_to_photos_outlined,
                          size: 25,
                        ),
                        title: const Text("Saved Posts",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              // color: Colors.black
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SavedPost()
                                      .savedPostsPage(
                                          data.docs[userIndex]["savedPost"])));
                        },
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ListTile(
                        leading: const Icon(
                          Icons.settings,
                          size: 25,
                        ),
                        title: const Text("Settings",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsPage()));
                        },
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout_outlined,
                          size: 25,
                        ),
                        title: const Text("Sign Out",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            )),
                        onTap: () async {
                          // signing out the user
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Fluttertoast.showToast(msg: "You Have Signed Out");
                        },
                      ),
                    ),
                    const Spacer(), // used to fill up all the free space in the Drawer
                    Text(
                      "Version $currentAppVersion",
                      style: const TextStyle(
                        fontFamily: "VareLaRound",
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      // isThereANewUpdate() == false ? showNewUpdateDialoge() : const SizedBox(),
      // const ShowNewUpdateAlert(),
    ]);
  }
}
