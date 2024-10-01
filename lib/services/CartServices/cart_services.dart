import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/cart_model.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class CartServices {
  final String? userId;
  late final CollectionReference _cartStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CartServices() {

  //   String? id = FirebaseAuth.instance.currentUser?.uid;
  //   _cartStorage = FirebaseFirestore.instance.collection('Users-Cart');
  //   if (id != null && id.isNotEmpty) {
  //     userId = id;
  //   }
  // }

  CartServices()
      : userId = FirebaseAuth.instance.currentUser?.uid,
        _cartStorage = FirebaseFirestore.instance.collection('Users-Cart');

  Future<void> addProductToCart(
      ProductModel product, BuildContext context, String quantity) async {
    if (userId == null) return;

    try {
      String cartId = const Uuid().v4();
      DocumentReference currentUserCartDoc = _cartStorage.doc(userId);

      // Fetch the existing document
      DocumentSnapshot ds = await currentUserCartDoc.get();

      // If the document exists, get the existing products
      List<ProductModel> cartProducts = [];

      String? createdAt = (ds.exists)
          ? CartModel.fromJson(ds.data()! as Map<String, dynamic>).createdAt
          : DateTime.now().toString();

      CartModel cm = CartModel();

      if (ds.exists) {
        cm = CartModel.fromJson(ds.data()! as Map<String, dynamic>);

        for (var p in cm.products!) {
          if (product.id == p.id) {
            quantity = (int.parse(quantity) + int.parse(p.stock!)).toString();
          } else {
            cartProducts.add(p);
          }
        }
      }

      // Add the new product to the list
      product.stock = quantity;
      cartProducts.add(product);

      // Update the document with the merged product list
      await currentUserCartDoc
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  CartModel.fromJson(snapshot.data()!),
              toFirestore: (CartModel, _) => CartModel.toJson())
          .set(CartModel(
            createdAt: createdAt,
            id: cartId,
            products: cartProducts,
            updatedAt: DateTime.now().toString(),
            userId: userId,
          ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.themeColor,
          content: Text(
            "Item added to cart",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      );
    } catch (e) {
      Vx.log("Error while adding item to Cart: ${e.toString()}");
    }
  }

  Future<List<ProductModel>> getCartProduct() async {
    if (userId == null) return [];

    try {
      DocumentSnapshot ds = await _cartStorage.doc(userId).get();
      return ds.exists
          ? (CartModel.fromJson(ds.data()! as Map<String, dynamic>).products ??
              [])
          : [];
    } catch (e) {
      Vx.log("Error while getting Cart Item: ${e.toString()}");
      return [];
    }
  }

  Future<void> deleteCartProduct(String productId) async {
    if (userId == null) return;
    try {
      DocumentSnapshot ds = await _cartStorage.doc(userId).get();

      if (!ds.exists) return;

      List<ProductModel> cartProducts =
          CartModel.fromJson(ds.data()! as Map<String, dynamic>).products ?? [];

      cartProducts.removeWhere((product) => product.id == productId);

      await _cartStorage.doc(userId).update({
        'products': cartProducts.map((product) => product.toJson()).toList(),
        'updatedAt': DateTime.now().toString()
      });
    } catch (e) {
      Vx.log("Error while Deleting item from Cart: ${e.toString()}");
    }
  }

  Future<void> emptyCart() async {
    if (userId == null) return;
    try {
      await _cartStorage.doc(userId).delete();
    } catch (e) {
      Vx.log("Error while Deleting item from Cart: ${e.toString()}");
    }
  }
}
