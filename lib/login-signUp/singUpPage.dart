// import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/login-signUp/loginPage.dart';
import 'package:readlex/main.dart';
import 'package:readlex/fireStoreHandeler/handeler.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /* 
  text controllers 
    userGmail
    userPassword
  */
  TextEditingController userName = TextEditingController();
  TextEditingController userGmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  @override
  void dispose() {
    userGmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(40),
                padding: const EdgeInsets.all(40),
                // width: 300,
                // height: 350,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(20, 20),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0),
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset.zero,
                          blurRadius: 0.0,
                          spreadRadius: 0.0),
                    ]),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.blueAccent[400],
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      fontFamily: "VareLaRound",
                      // letterSpacing: 2
                    ),
                  ),
                  const SizedBox(height: 20),
                  // gmail text feild
                  TextField(
                    // obscureText: true,
                    autofocus: true,
                    controller: userName,
                    // cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      label: Text(
                        "username",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // User's password text feild
                  TextField(
                    // obscureText: true,
                    controller: userGmail,
                    // cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      label: Text(
                        "Email",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // User's password text feild
                  TextField(
                    // obscureText: true,
                    controller: userPassword,
                    // cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      label: Text(
                        "Password",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: "Already have an Account?",
                      style: TextStyle(
                        fontFamily: "VareLaRound",
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                        text: " Login",
                        style: const TextStyle(
                          fontFamily: "VareLaRound",
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                          })
                  ])),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      singin();
                      setState(() {
                        isLoading = false;
                      });
                    },
                    icon: const Icon(
                      Icons.login_sharp,
                      color: Colors.black87,
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Colors.blueAccent)))),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "VareLaRound",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
  }

  void singin() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userGmail.text.trim(), password: userPassword.text.trim());
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(userName.text.trim());
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(
          "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F13%2F2015%2F04%2F05%2Ffeatured.jpg&q=60");
      // String usrphotoUrl = user.photoURL!;
      await FirebaseAuth.instance.currentUser!.reload();
      writeNewUserData(
          FirebaseAuth.instance.currentUser!.displayName!,
          FirebaseAuth.instance.currentUser!.email!,
          FirebaseAuth.instance.currentUser!.photoURL!,
          FirebaseAuth.instance.currentUser!.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      // Fluttertoast.showToast(
      // msg: (FirebaseAuth.instance.currentUser!.displayName).toString());
    } on FirebaseAuthException catch (errorMsg) {
      Fluttertoast.showToast(
          msg: "${errorMsg.message}", gravity: ToastGravity.TOP);
    }
  }
}
