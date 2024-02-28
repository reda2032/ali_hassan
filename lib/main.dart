import 'package:ali_hassan/firebase_options.dart';
import 'package:ali_hassan/flower_app/pages/register.dart';
import 'package:ali_hassan/flower_app/provider/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: Register(),
      ),
    );
  }
}
