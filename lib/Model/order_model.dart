import 'package:myshop/Model/address.dart';

class OrderModel {
  String? id;
  String? userId;
  List<Products>? products;
  String? totalAmount;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  Address? shippingAddress;

  OrderModel(
      {this.id,
      this.userId,
      this.products,
      this.totalAmount,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.shippingAddress});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add( Products.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    shippingAddress = json['shippingAddress'] != null
        ?  Address.fromJson(json['shippingAddress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    data['orderStatus'] = orderStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    return data;
  }
}

class Products {
  String? productId;
  String? quantity;

  Products({this.productId, this.quantity});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}
