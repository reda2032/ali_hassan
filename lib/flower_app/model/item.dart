class Item {
  String imgPath;
  double price;

  Item({
    required this.imgPath,
    required this.price,
  });
}

final List<Item> items = [
  Item(price: 112.99, imgPath: "assets/img/1.webp"),
  Item(price: 122.99, imgPath: "assets/img/2.webp"),
  Item(price: 123.99, imgPath: "assets/img/3.webp"),
  Item(price: 142.99, imgPath: "assets/img/4.webp"),
  Item(price: 162.99, imgPath: "assets/img/5.webp"),
  Item(price: 172.99, imgPath: "assets/img/6.webp"),
  Item(price: 182.99, imgPath: "assets/img/7.webp"),
  Item(price: 192.99, imgPath: "assets/img/8.webp"),
];
