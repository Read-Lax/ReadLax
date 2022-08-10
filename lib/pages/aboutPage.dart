import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "About",
          style: TextStyle(
            fontFamily: "VareLaRound",
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
            backgroundImage: Image.asset(
              "assets/app_logo.png",
            ).image,
            backgroundColor: Colors.grey.shade100,
            radius: 50.0,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            "@2022 ReadLax",
            style: TextStyle(
              fontFamily: "VareLaRound",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    Colors.greenAccent,
                    Colors.blueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Text(
                  " '' The idea behind this app is provided by the developper's mother so shout out to her and to all The other moms. '' ❤️",
                  style: TextStyle(
                    fontFamily: "VareLaRound",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
