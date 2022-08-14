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
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // Colors.green,
                    Colors.greenAccent,
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: Image.asset("assets/app_logo.png").image,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    radius: 50,
                  ),
                  Text(
                    "Readlax",
                    style: TextStyle(
                      fontFamily: "VareLaRound",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(20, 20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          // Colors.green,
                          Colors.greenAccent,
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 37,
                          fontWeight: FontWeight.bold,
                          fontFamily: "VareLaRound",
                          // letterSpacing: 2
                        ),
                      ),
                      const SizedBox(height: 20),
                      // gmail text feild
                      TextField(
                        controller: userGmail,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 125, 145),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
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
                        obscureText: true,
                        controller: userPassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          label: Text(
                            "Password",
                            style: TextStyle(
                              fontFamily: "VareLaRound",
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
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
                              // fontWeight: FontWeight.bold,
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
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.greenAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        label: const Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: "VareLaRound",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          );
  }

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userGmail.text.trim(), password: userPassword.text.trim());
      Fluttertoast.showToast(
          msg: "Welcome back " +
              FirebaseAuth.instance.currentUser!.displayName.toString());
      // setState(() {});
    } on FirebaseAuthException catch (errorMsg) {
      Fluttertoast.showToast(
          msg: "${errorMsg.message}", gravity: ToastGravity.TOP);
    }
  }
}
