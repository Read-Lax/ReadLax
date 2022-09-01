import 'package:flutter/material.dart';
import 'package:readlex/screens/settings/appearance/appearance_setting.dart';
import 'package:readlex/screens/settings/acounts_data/account_data.dart';
import 'package:readlex/screens/settings/about/about_the_app.dart';

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
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserProfilePage()));
              },
              leading: const Icon(Icons.account_box_sharp),
              title: const Text(
                "Account Settings",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              subtitle: const Text(
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              leading: const Icon(Icons.tips_and_updates_outlined),
              title: const Text(
                "Appearance",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              subtitle: const Text(
                "Dark Mode...",
                style: TextStyle(
                  fontFamily: "VareLaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AppearancePage()));
              },
            ),
          ),
          Card(
            elevation: 3,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: ListTile(
              onTap: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
              leading: const Icon(Icons.more_outlined),
              title: const Text(
                "About",
                style: TextStyle(
                    fontFamily: "VareLaRound", fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              subtitle: const Text(
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
