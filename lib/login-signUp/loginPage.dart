import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'singUpPage.dart';
import 'package:readlex/shared/mostUsedFunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /* 
  text controllers 
    userGmail
    userPassword
  */
  TextEditingController userGmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    userGmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
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
                    "Login Page",
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
                    controller: userGmail,
                    // cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      label: Text(
                        "Gmail",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          // color: Colors.black45,
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
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      label: Text(
                        "Password",
                        style: TextStyle(
                          fontFamily: "VareLaRound",
                          fontWeight: FontWeight.bold,
                          // color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                      text: "Don't have an Account?",
                      style: TextStyle(
                        fontFamily: "VareLaRound",
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                        text: " SingUp",
                        style: const TextStyle(
                          fontFamily: "VareLaRound",
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                            setState(() {});
                          })
                  ])),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      login();
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
                      "Login",
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

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userGmail.text.trim(), password: userPassword.text.trim());
    } on FirebaseAuthException catch (errorMsg) {
      Fluttertoast.showToast(
          msg: "${errorMsg.message}", gravity: ToastGravity.TOP);
    }
  }
}
