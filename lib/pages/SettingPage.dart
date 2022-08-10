import 'package:flutter/material.dart';
import 'package:readlex/pages/AppearanceSetting.dart';
import 'package:readlex/pages/UserProfilePage.dart';
import 'package:readlex/pages/aboutPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: "VareLaRound",
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.greenAccent,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
              leading: Icon(Icons.account_box_sharp),
              title: Text(
                "Account Settings",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              subtitle: Text(
                "Change username, email, profile photo...",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              leading: Icon(Icons.tips_and_updates_outlined),
              title: Text(
                "Appearance",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              subtitle: Text(
                "Dark Mode...",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppearancePage()));
              },
            ),
          ),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              onTap: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
              leading: Icon(Icons.more_outlined),
              title: Text(
                "About",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              subtitle: Text(
                "the story behind this app",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
