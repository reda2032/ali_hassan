import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextInputType textInputType;
  final bool isPassword;
  final String hintText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.textInputType,
    required this.isPassword,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          // To delete borders
          enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          // fillColor: Colors.red,
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ));
  }
}
