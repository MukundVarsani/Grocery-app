import 'package:myshop/Model/product_model.dart';

class SingleCategoryModel {
  String? categoryName;
  List<ProductModel>? products;

  SingleCategoryModel({this.categoryName, this.products});

  SingleCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if (json['products'] != null) {
      products = <ProductModel>[];
      json['products'].forEach((v) {
        products!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
