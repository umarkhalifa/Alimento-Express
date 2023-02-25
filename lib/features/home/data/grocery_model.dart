import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Grocery {
  String name;
  String image;
  int price;
  double rating;
  String category;

  Grocery(
      {required this.name, required this.image, required this.price, required this.rating,required this.category});

}

List<Grocery> groceries = [
  Grocery(name: "Apple", image: "assets/images/apple.png", price: 300, rating: 4.9,category: "Fruits"),
  Grocery(name: "Strawberries", image: "assets/images/strawberries.png", price: 500, rating: 3.4,category: "Fruits"),
  Grocery(name: "Orange", image: "assets/images/orange.png", price: 100, rating: 3.5,category: "Fruits"),
  Grocery(name: "Peach", image: "assets/images/peach.png", price: 600, rating: 4.1,category: "Fruits"),
  Grocery(name: "Pomegranate", image: "assets/images/pomegranate.png", price: 300, rating: 4.0,category: "Fruits"),
  Grocery(name: "Pineapple", image: "assets/images/pineapple.png", price: 400, rating: 3.9,category: "Fruits"),
  Grocery(name: "Red Cherries", image: "assets/images/redcherries.png", price: 350, rating: 4.4,category: "Fruits"),
  Grocery(name: "Squash", image: "assets/images/Squash.png", price: 700, rating: 4.1,category: "Vegetables"),
  Grocery(name: "Carrot", image: "assets/images/carrot.png", price: 200, rating: 3.8,category: "Vegetables"),
  Grocery(name: "Ginger", image: "assets/images/ginger.png", price: 400, rating: 4.1,category: "Vegetables"),
  Grocery(name: "Broccoli", image: "assets/images/broccoli.png", price: 600, rating: 4.5,category: "Vegetables"),
  Grocery(name: "Cabbage", image: "assets/images/cabbage.png", price: 800, rating: 4.9,category: "Vegetables"),
  Grocery(name: "Pepper", image: "assets/images/pepper.png", price:6600, rating: 4.1,category: "Vegetables"),
  Grocery(name: "Bournvita", image: "assets/images/bournvita.png", price: 400, rating: 3.8,category: "Breakfast"),
  Grocery(name: "Corn Flakes", image: "assets/images/corn_flakes.png", price: 300, rating:4.1,category: "Breakfast"),
  Grocery(name: "Indomie", image: "assets/images/indomie.png", price: 700, rating: 3.5,category: "Breakfast"),
  Grocery(name: "Macaroni", image: "assets/images/macaroni.png", price: 200, rating: 3.2,category: "Breakfast"),
  Grocery(name: "Spaghetti", image: "assets/images/spaghetti.png", price: 1000, rating: 4.3,category: "Breakfast"),
  Grocery(name: "Onions", image: "assets/images/onions.png", price: 1500, rating: 4.0,category: "Breakfast"),
  Grocery(name: "Potatoes", image: "assets/images/potatoes.png", price: 1600, rating: 4.5,category: "Breakfast"),
  Grocery(name: "Tomato", image: "assets/images/tomato.png", price: 1800, rating: 4.3,category: "Breakfast"),

];
// List<Grocery> groceries = [
//   Grocery(name: "Bournvita",
//       image: "assets/images/bournvita.png",
//       price: 5000,
//       rating: 3.8),
//   Grocery(
//       name: "Milo", image: "assets/images/milo.png", price: 6500, rating: 3.8),
//   Grocery(name: "Nivea Men",
//       image: "assets/images/nivea1.png",
//       price: 2000,
//       rating: 3.8),
//   Grocery(name: "Nivea Women",
//       image: "assets/images/nivea2.png",
//       price: 2500,
//       rating: 3.8),
//   Grocery(name: "Spaghetti",
//       image: "assets/images/spaghetti.png",
//       price: 8000,
//       rating: 3.8),
//   Grocery(name: "Macaroni",
//       image: "assets/images/macaroni.png",
//       price: 6000,
//       rating: 3.8),
//   Grocery(name: "Peak Milk",
//       image: "assets/images/milk.png",
//       price: 4800,
//       rating: 3.8),
//   Grocery(name: "Power oil",
//       image: "assets/images/oil.png",
//       price: 5000,
//       rating: 3.8),
//   Grocery(name: "Onions",
//       image: "assets/images/onions.png",
//       price: 150,
//       rating: 3.8),
//   Grocery(name: "Tomato",
//       image: "assets/images/tomato.png",
//       price: 100,
//       rating: 3.8),
//   Grocery(name: "Pepper",
//       image: "assets/images/pepper.png",
//       price: 100,
//       rating: 3.8),
//   Grocery(name: "Potatoes",
//       image: "assets/images/potatoes.png",
//       price: 2000,
//       rating: 3.8),
//   Grocery(name: "Basket",
//       image: "assets/images/basket.png",
//       price: 1500,
//       rating: 3.8),
//   Grocery(name: "Grapes",
//       image: "assets/images/grapes.png",
//       price: 350,
//       rating: 3.8),
//   Grocery(name: "Cabbage",
//       image: "assets/images/cabbage.png",
//       price: 500,
//       rating: 3.8),
//   Grocery(
//       name: "Mango", image: "assets/images/mango.png", price: 300, rating: 3.8),
// ];


Future<File> getImageFileFromAssets(String img) async {
  String imageName = img.substring(img.lastIndexOf("/"), img.lastIndexOf("."));

  String path = img.substring(img.indexOf("/") + 1, img.lastIndexOf("/"));
  print(imageName);
  final Directory systemTempDir = Directory.systemTemp;
  final byteData = await rootBundle.load(img);
  final file = File('${systemTempDir.path}/$imageName.png');

  await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}

class FirebaseMeth {
  void addTickets() async {
    for (Grocery grocery in groceries) {
      File file = await getImageFileFromAssets(grocery.image);
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      final trying = await firebaseStorage.ref(grocery.name).putFile(file);
      String url = await trying.ref.getDownloadURL();
      print(url);
      FirebaseFirestore.instance.collection("PRODUCTS")
          .doc(const Uuid().v4())
          .set({
        "name": grocery.name,
        "image": url,
        "price": grocery.price,
        "rating": grocery.rating,
        "category": grocery.category
      });
    }
  }
}
