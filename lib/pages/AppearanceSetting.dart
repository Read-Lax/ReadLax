import 'package:flutter/material.dart';
import 'package:readlex/provider/themeProvider.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Appearance",
          style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 30,
              fontFamily: "VareLaRound",
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text(
              "Dark Mode",
              style: TextStyle(
                fontFamily: "VareLaRound",
              ),
            ),
            trailing: Switch.adaptive(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                }),
          )
        ],
      ),
    );
  }
}
