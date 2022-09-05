import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readlex/Widgets/loading_indicator.dart';
import 'package:readlex/screens/login/login_screen.dart';
import 'package:readlex/main.dart';
import 'package:readlex/services/add_new_user_data.dart';

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
        ? const LoadingCircule()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    // Colors.green,
                    Colors.greenAccent,
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    CircleAvatar(
                      backgroundImage: Image.asset("assets/app_logo.png").image,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: 50,
                    ),
                    const Text(
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
                      // width: 300,
                      // height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(20, 20),
                        ),
                        gradient: const LinearGradient(
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
                        const Text(
                          "Sign Up",
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
                          // obscureText: true,
                          autofocus: true,
                          controller: userName,
                          // cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 125, 145),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
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
                          // cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 125, 145),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
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
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.greenAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                          label: const Text(
                            "Sign Up",
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
            ),
          );
  }

  void singin() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userGmail.text.trim(), password: userPassword.text.trim());
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(userName.text.trim());
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(
          "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F13%2F2015%2F04%2F05%2Ffeatured.jpg&q=60");
      // String usrphotoUrl = user.photoURL!;
      await FirebaseAuth.instance.currentUser!.reload();
      addNewUserData(
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
