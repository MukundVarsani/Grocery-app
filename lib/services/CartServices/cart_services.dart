import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/cart_model.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class CartServices {
  String? userId;
  late CollectionReference _cartStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CartServices() {
    String? id = FirebaseAuth.instance.currentUser?.uid;
    _cartStorage = FirebaseFirestore.instance.collection('Users-Cart');
    if (id != null && id.isNotEmpty) {
      userId = id;
    }
  }

  Future<void> addProductToCart(
      ProductModel product, BuildContext context, String quantity) async {
    try {
      String cartId = const Uuid().v4();
      DocumentReference currentUserCartDoc = _cartStorage.doc(userId);

      // Fetch the existing document
      DocumentSnapshot ds = await currentUserCartDoc.get();

      // If the document exists, get the existing products
      List<ProductModel> cartProducts = ds.exists
          ? (CartModel.fromJson(ds.data()! as Map<String, dynamic>).products ??
              [])
          : [];

     

    String? CreatedAt =  (ds.exists) ? CartModel.fromJson(ds.data()! as Map<String, dynamic>).createdAt : DateTime.now().toString(); 

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
            createdAt: (CreatedAt != null) ? CreatedAt : DateTime.now().toString() ,
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
      Vx.log("Error while adding item to storage: ${e.toString()}");
    }
  }
}
