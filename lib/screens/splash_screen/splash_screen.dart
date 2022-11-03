import 'package:flutter/material.dart';
import 'package:readlex/main.dart';

class SplashScreen extends StatefulWidget {
  Widget whatToReturn;
  SplashScreen({Key? key, required Widget this.whatToReturn}) : super(key: key);

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
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => widget.whatToReturn));
      // return ShowPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
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
           ],
        ),
      ),
    );
  }
}
