import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/data/order_model.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Grocery>> fetchGroceries() async {
    List<Grocery> grocery = [];

    final response = await firestore.collection("PRODUCTS").get();
    for (var element in response.docs) {
      Grocery data = Grocery(
          name: element.data()['name'],
          image: element.data()['image'],
          price: element.data()['price'],
          category: element.data()['category'],
          rating: element.data()['rating']);
      grocery.add(data);
    }
    return grocery;
  }

  Future<void> addToCart(Cart order) async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection("USERS").doc(uuid).collection("CART").add({
      "amount": order.amount,
      "name": order.name,
      "price": order.price,
      "image": order.image
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchCart() async* {
    List<Cart> orders = [];
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    yield* firestore
        .collection("USERS")
        .doc(uuid)
        .collection("CART")
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrder() async* {
    List<Cart> orders = [];
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    yield* firestore
        .collection("USERS")
        .doc(uuid)
        .collection("ORDERS")
        .snapshots();
  }

  Future<void> incrementCart(String uid) async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    firestore
        .collection("USERS")
        .doc(uuid)
        .collection("CART")
        .doc(uid)
        .update({"amount": FieldValue.increment(1)});
  }

  Future<void> decrementCart(String uid) async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    firestore
        .collection("USERS")
        .doc(uuid)
        .collection("CART")
        .doc(uid)
        .update({"amount": FieldValue.increment(-1)});
  }

  Future<void> deleteCartItem(String uid) async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    firestore
        .collection("USERS")
        .doc(uuid)
        .collection("CART")
        .doc(uid)
        .delete();
  }

//  CLEAR CART
  Future<void> clearCart() async {
    final batch = firestore.batch();
    var snapShots = await firestore
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CART")
        .get();
    for (var doc in snapShots.docs) {
      batch.delete(doc.reference);
    }
    batch.commit();
  }

//  ADD ORDER
  Future<void> addOrder() async {
    Uuid uuid = const Uuid();
    firestore
        .collection("USERS")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CART")
        .snapshots()
        .forEach((element) async {
      for (var item in element.docs) {
        Cart cart = Cart(
            image: item.data()['image'],
            price: item.data()['price'],
            name: item.data()['name'],
            amount: item.data()['amount']);
        await firestore
            .collection("USERS")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("ORDERS")
            .doc(uuid.v4())
            .set({
          "date": DateTime.now(),
          "status": false,
          "image": cart.image,
          "name": cart.name,
          "price": cart.price,
          "AMOUNT": cart.amount
        });
      }
    });
    clearCart();
  }
}

final firebaseProvider = Provider((ref) => FirebaseMethods());
