import 'package:ali_hassan/flower_app/pages/login.dart';
import 'package:ali_hassan/flower_app/shared/colors.dart';
import 'package:ali_hassan/flower_app/shared/custom_textfield.dart';
import 'package:ali_hassan/flower_app/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
        //  print('The account already exists for that email.');
      } else {
        showSnackBar(context, "ERROR - Please try again late");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    setState(() {
      isLoading = false;
    });
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
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64.0),
              // Enter Your Email
              MyTextField(
                controller: emailController,
                hintText: 'Enter Your User Name :',
                isPassword: false,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 32.0),
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
              // Sign in Register
              ElevatedButton(
                onPressed: () {
                  register();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(BTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(height: 32.0),
              // Do not have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
