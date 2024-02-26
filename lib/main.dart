import 'package:ali_hassan/flower_app/pages/home.dart';
import 'package:ali_hassan/flower_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return CartProvider();
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flower App',
        home: Home(),
      ),
    );
  }
}
