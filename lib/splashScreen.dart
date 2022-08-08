import 'package:flutter/material.dart';
import 'package:readlex/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToTheMainPage();
  }

  _navigateToTheMainPage() async {
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ShowPage()));
      // return ShowPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent,
              // Colors.blueAccent,
              Colors.white
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: Image.asset(
                "assets/app_logo.png",
              ).image,
              backgroundColor: Colors.transparent,
              radius: 70.0,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Readlax",
              style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 47,
                  color: Colors.greenAccent),
            )
          ],
        ),
      ),
    );
  }
}
