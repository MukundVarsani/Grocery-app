import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/address.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderServices {
  final CollectionReference _orderStorage;
  final String? userid;
  final Address shippingAddress = Address(
    city: "Bhuj",
    country: "India",
    postalCode: "789078",
    street: "Naranpura",
  );
  late final UserProvider _userServices;

  OrderServices()
      : userid = FirebaseAuth.instance.currentUser?.uid,
        _orderStorage = FirebaseFirestore.instance.collection('User-Orders');

  Future<bool> makeOrder(
      List<ProductModel> cartProducts, BuildContext context) async {
    _userServices = Provider.of<UserProvider>(context, listen: false);
    UserModel? currentUser = _userServices.getCurrentUser;

    if (currentUser == null) return false;
    if (cartProducts.isEmpty) return false;

    try {
      late String userId;
      late Address shippingAddress;
      if (currentUser.id != null) {
        userId = currentUser.id!;
      }
      if (currentUser.address == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.themeColor,
            content: Text(
              "Please set Address",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        );

        return false;
      } else {
        shippingAddress = currentUser.address!;
      }

      String orderId = const Uuid().v4();
      DocumentReference currentUserOrderDoc = _orderStorage.doc(userId);
      DocumentSnapshot ds = await currentUserOrderDoc.get();
      List<ProductModel> orderProducts = [];

      String? createdAt = (ds.exists)
          ? OrderModel.fromJson(ds.data()! as Map<String, dynamic>).createdAt
          : DateTime.now().toString();

      OrderModel om = OrderModel();

      int total = 0;

      if (ds.exists) {
        om = OrderModel.fromJson(ds.data()! as Map<String, dynamic>);
        for (var product in om.products!) {
          total =
              total + (int.parse(product.price!) * int.parse(product.stock!));
          orderProducts.add(product);
        }
      }

      for (ProductModel product in cartProducts) {
        total = total + (int.parse(product.price!) * int.parse(product.stock!));
      }

      for (var p in cartProducts) {
        orderProducts.add(p);
      }

      await currentUserOrderDoc
          .withConverter(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()!),
            toFirestore: (OrderModel, _) => OrderModel.toJson(),
          )
          .set(OrderModel(
              createdAt: createdAt,
              id: orderId,
              orderStatus: "1",
              products: orderProducts,
              shippingAddress: shippingAddress,
              totalAmount: total.toString(),
              updatedAt: DateTime.now().toString(),
              userId: userId));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.themeColor,
          content: Text(
            "Order Placed",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      );
      return true;
    } catch (e) {
      Vx.log("Error on Ordering Item: ${e.toString()}");
    }

    return false;
  }

  Future<OrderModel> getOrder() async {
    if (userid == null) return OrderModel();
    try {
      DocumentSnapshot ds = await _orderStorage.doc(userid).get();

      return ds.exists
          ? (OrderModel.fromJson(ds.data()! as Map<String, dynamic>))
          : OrderModel();
    } catch (e) {
      Vx.log("Error while Getting Order product: ${e.toString()}");
      return OrderModel();
    }
  }
}
