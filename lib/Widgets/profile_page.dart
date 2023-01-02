import 'package:flutter/material.dart';
import 'package:readlex/screens/user_profile/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userUID});
  final String userUID;
  
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: usersProfile(
        widget.userUID,
        context,
      ),
    );
  }
}
