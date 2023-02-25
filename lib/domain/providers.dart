import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/data/auth_data_source.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';

final fetchGroceriesProvider = FutureProvider<List<Grocery>>((ref) => ref.read(firebaseProvider).fetchGroceries());
final cartProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) => ref.watch(firebaseProvider).fetchCart());
final orderProvider = StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) => ref.watch(firebaseProvider).fetchOrder());
final authStatusProvider = StreamProvider((ref) => ref.watch(authServiceProvider).user);