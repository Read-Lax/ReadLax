import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = Get.isDarkMode ? true : false;
  late Color backButtonColor;
  // setBackButtonColor() {
  //   setState(() {
  //     if (Get.isDarkMode) {
  //       backButtonColor = Colors.white;
  //     } else {
  //       Colors.black;
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back_sharp,
        //       color: backButtonColor,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
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
            child: Column(
              children: [
                const Text(
                  "Appearance",
                  style: TextStyle(
                    textBaseline: TextBaseline.ideographic,
                    fontFamily: "VareLaRound",
                    // fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dark More",
                      style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                    Switch(
                        value: isDarkMode,
                        autofocus: true,
                        focusColor: Colors.green[50],
                        hoverColor: Colors.greenAccent,
                        activeColor: Colors.greenAccent,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.green[100],
                        onChanged: (bool darkMode) {
                          setState(() {
                            isDarkMode ? isDarkMode = false : isDarkMode = true;
                          });
                          isDarkMode
                              ? Get.changeTheme(ThemeData.dark())
                              : Get.changeTheme(ThemeData.light());
                        })
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
