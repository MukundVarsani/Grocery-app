import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminOrderService {
  final CollectionReference _orderStorage;

  late final UserProvider _userServices;

  AdminOrderService()
      : _orderStorage = FirebaseFirestore.instance.collection('User-Orders');

  Future<List<OrderModel>> getAllOrder() async {
    // if (userid == null) return [OrderModel()];
    try {
      List<OrderModel> orders = [];

      QuerySnapshot ds = await _orderStorage.get();

      for (var d in ds.docs) {
        if (d.exists) {
          // Convert document data into OrderModel and add to orders list
          orders.add(OrderModel.fromJson(d.data()! as Map<String, dynamic>));
        }
      }

      return orders;
    } catch (e) {
      Vx.log("Error while Getting Order product: ${e.toString()}");
      return [OrderModel()];
    }
  }

  Future<OrderModel> getUserOrders({required String userId}) async {
    try {
      DocumentSnapshot ds = await _orderStorage.doc(userId).get();

      return ds.exists
          ? (OrderModel.fromJson(ds.data()! as Map<String, dynamic>))
          : OrderModel();
    } catch (e) {
      Vx.log("Error while Getting all user Orders : ${e.toString()}");
      return OrderModel();
    }
  }

  Future<void> updateOrderStatus(
      {required String userId, required String statusCode}) async {
    try {
      DocumentSnapshot ds = await _orderStorage.doc(userId).get();

      OrderModel om = OrderModel.fromJson(ds.data()! as Map<String, dynamic>);
      om.orderStatus = statusCode;

      await _orderStorage.doc(userId).set(
        om.toJson(),
      );
    } catch (e) {
      Vx.log("Error while updating Order status: ${e.toString()}");
      return;
    }
  }
}
