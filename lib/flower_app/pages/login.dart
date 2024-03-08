import 'package:ali_hassan/flower_app/pages/forgot_passowrd.dart';
import 'package:ali_hassan/flower_app/pages/home.dart';
import 'package:ali_hassan/flower_app/pages/register.dart';
import 'package:ali_hassan/flower_app/provider/google_signin.dart';
import 'package:ali_hassan/flower_app/shared/colors.dart';
import 'package:ali_hassan/flower_app/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../shared/custom_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showSnackBar(context, "doneee");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64.0),
              // Enter Your Email
              MyTextField(
                controller: emailController,
                hintText: 'Enter Your Email :',
                isPassword: false,
                textInputType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 32.0),
              // Enter Your Password
              MyTextField(
                controller: passwordController,
                hintText: 'Enter Your Password :',
                isPassword: true,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32.0),
              // Sign in
              ElevatedButton(
                onPressed: () async {
                  if (!mounted) return;
                  await signIn();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(BTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: const Text(
                  "Sign in",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()),
                  );
                },
                child: const Text("Forgot password?",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline)),
              ),
              // Do not have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do not have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      'sign up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 299,
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                    )),
                    Text(
                      "OR",
                      style: TextStyle(),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                    )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 27),
                child: GestureDetector(
                  onTap: () {
                    googleSignInProvider.googlelogin();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            // color: Colors.purple,
                            color: const Color.fromARGB(255, 200, 67, 79),
                            width: 1)),
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      color: const Color.fromARGB(255, 200, 67, 79),
                      height: 27,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
