import 'package:ali_hassan/flower_app/model/item.dart';
import 'package:ali_hassan/flower_app/pages/details_screen.dart';
import 'package:ali_hassan/flower_app/provider/cart_provider.dart';
import 'package:ali_hassan/flower_app/shared/appbar.dart';
import 'package:ali_hassan/flower_app/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/img/test.jpg"),
                        fit: BoxFit.cover),
                  ),
                  currentAccountPicture: CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage("assets/img/ali.jpg")),
                  accountEmail: Text("ali@yahoo.com"),
                  accountName: Text("ali Hassan",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                ),
                ListTile(
                    title: const Text("Home"),
                    leading: const Icon(Icons.home),
                    onTap: () {}),
                ListTile(
                    title: const Text("My products"),
                    leading: const Icon(Icons.add_shopping_cart),
                    onTap: () {}),
                ListTile(
                    title: const Text("About"),
                    leading: const Icon(Icons.help_center),
                    onTap: () {}),
                ListTile(
                    title: const Text("Logout"),
                    leading: const Icon(Icons.exit_to_app),
                    onTap: () {}),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text("Developed by Ali Hassan © 2022",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: const [
          ProductsAndPrice(),
          /* Row(
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
                      child: Text(
                        cartProvider.selectedProducts.length.toString(),
                        style: const TextStyle(
                            fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                  // add_shopping_cart
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_shopping_cart),
                  ),
                ],
              ),
              // value 13 usd
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  cartProvider.price.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),*/
        ],
        backgroundColor: appbarGreen,
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 33),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          product: items[index],
                        ),
                      ));
                },
                child: GridTile(
                  footer: GridTileBar(
                    // backgroundColor: Color.fromARGB(66, 73, 127, 110),
                    trailing: IconButton(
                      color: const Color.fromARGB(255, 62, 94, 70),
                      onPressed: () {
                        cartProvider.add(items[index]);
                      },
                      icon: const Icon(Icons.add),
                    ),

                    leading: Text('\$ ${items[index].price}'),

                    title: const Text(
                      "",
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: -3,
                      bottom: -9,
                      right: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Image.asset(items[index].imgPath),
                      ),
                    ),
                  ]),
                ),
              );
            }),
      ),
    );
  }
}
