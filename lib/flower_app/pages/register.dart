import 'dart:io';
import 'dart:math';

import 'package:ali_hassan/flower_app/pages/login.dart';
import 'package:ali_hassan/flower_app/shared/colors.dart';
import 'package:ali_hassan/flower_app/shared/contants.dart';
import 'package:ali_hassan/flower_app/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  bool isVisable = true;
  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  File? imgPath;
  String? imgName;

  onPasswordChanged(String password) {
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }

      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }

      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }

      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }

      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imgName);
      await storageRef.putFile(imgPath!);
      String url = await storageRef.getDownloadURL();

      print(credential.user!.uid);
      CollectionReference users =
          FirebaseFirestore.instance.collection('usersss');

      users
          .doc(credential.user!.uid)
          .set({
            'imgLink': url,
            'username': usernameController.text,
            'age': ageController.text,
            "title": titleController.text,
            "email": emailController.text,
            "pass": passwordController.text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    ageController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(125, 78, 91, 110),
                  ),
                  child: Stack(
                    children: [
                      imgPath == null
                          ? const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 225, 225, 225),
                              radius: 71,
                              // backgroundImage: AssetImage("assets/img/avatar.png"),
                              backgroundImage:
                                  AssetImage("assets/img/avatar.png"),
                            )
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        left: 99,
                        bottom: -10,
                        child: IconButton(
                          onPressed: () {
                            //   uploadImage2Screen();
                            showmodel();
                          },
                          icon: const Icon(Icons.add_a_photo),
                          color: const Color.fromARGB(255, 94, 115, 128),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                //   Enter Your user name
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: emailController,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your User Name : ",
                      suffixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(height: 32.0),
                // Enter Your age :
                TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your age : ",
                        suffixIcon: const Icon(Icons.pest_control_rodent))),
                const SizedBox(
                  height: 22,
                ),
                // Enter Your title :
                TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your title : ",
                        suffixIcon: const Icon(Icons.person_outline))),
                const SizedBox(
                  height: 22,
                ),
                // Email
                TextFormField(
                  // we return "null" when something is valid
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? "Enterrrr a valid email"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: const Icon(Icons.email)),
                ),

                const SizedBox(height: 32.0),
                // Enter Your Password
                TextFormField(
                  onChanged: (password) {
                    onPasswordChanged(password);
                  },
                  // we return "null" when something is valid
                  validator: (value) {
                    return value!.length < 8
                        ? "Enter at least 8 characters"
                        : null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisable ? true : false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable = !isVisable;
                            });
                          },
                          icon: isVisable
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off))),
                ),
                const SizedBox(height: 32.0),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPassword8Char ? Colors.green : Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 189, 189, 189)),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text("At least 8 characters"),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isPasswordHas1Number ? Colors.green : Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 189, 189, 189)),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text("At least 1 number"),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasUppercase ? Colors.green : Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 189, 189, 189)),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text("Has Uppercase"),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasLowercase ? Colors.green : Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 189, 189, 189)),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text("Has  Lowercase "),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            hasSpecialCharacters ? Colors.green : Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 189, 189, 189)),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text("Has  Special Characters "),
                  ],
                ),
                const SizedBox(
                  height: 33,
                ),
                // Sign in Register
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        imgName != null &&
                        imgPath != null) {
                      await register();
                      if (!mounted) return;
                      showSnackBar(context, 'D O N E . . .');

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    } else {
                      showSnackBar(context, "ERROR");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(BTNgreen),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(12)),
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
                          MaterialPageRoute(
                              builder: (context) => const Login()),
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
      ),
    ));
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  uploadImage2Screen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}
