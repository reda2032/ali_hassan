import 'package:ali_hassan/flower_app/shared/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      actions: [
        Row(
          children: [
            Stack(
              children: [
                //  cart count
                Positioned(
                  bottom: 24,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(211, 164, 255, 193),
                          shape: BoxShape.circle),
                      child: const Text(
                        "8",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                      )),
                ),
                // add_shopping_cart
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart),
                ),
              ],
            ),
            // value 13 usd
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                "\$ 13",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
      backgroundColor: appbarGreen,
      title: const Text("Home"),
    ));
  }
}
