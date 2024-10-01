import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/single_category_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminService {
  late CollectionReference _productStorage;

  AdminService()
      : _productStorage =
            FirebaseFirestore.instance.collection('Products-Storage');



  Future<void> addItemToStorage(String category, String name, String id,
      ProductModel product, BuildContext context) async {
    try {
      DocumentReference categoryDoc = _productStorage.doc(category);

      // Fetch the existing document
      DocumentSnapshot ds = await categoryDoc.get();

      // If the document exists, get the existing products
      List<ProductModel> products = ds.exists
          ? (SingleCategoryModel.fromJson(ds.data()! as Map<String, dynamic>)
                  .products ??
              [])
          : [];

      // Add the new product to the list
      products.add(product);

      // Update the document with the merged product list
      await categoryDoc
          .withConverter<SingleCategoryModel>(
            fromFirestore: (snapshot, _) =>
                SingleCategoryModel.fromJson(snapshot.data()!),
            toFirestore: (SingleCategoryModel, _) =>
                SingleCategoryModel.toJson(),
          )
          .set(SingleCategoryModel(
            products: products,
            categoryName: category,
          ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.themeColor,
          content: Text(
            "Added Successfully",
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

  Future<List<ProductModel>> getSingleCategoryProducts(
      {required String category}) async {
    _productStorage = FirebaseFirestore.instance.collection('Products-Storage');
    List<ProductModel> catSortProduct = [];
    try {
      DocumentSnapshot? documentSnapshot =
          await _productStorage.doc(category).get();

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        SingleCategoryModel categoryModel = SingleCategoryModel.fromJson(
            documentSnapshot.data()! as Map<String, dynamic>);
        if (categoryModel.products != null) {
          catSortProduct = categoryModel.products!;
        }
      }
    } catch (e) {
      Vx.log("Error while fetching $category product: ${e.toString()}");
    }

    return catSortProduct;
  }


}
