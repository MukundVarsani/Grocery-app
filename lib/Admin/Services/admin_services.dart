import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/single_category_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminService {
  CollectionReference? _productStorage;
  late CollectionReference _reference;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AdminService() {
    _productStorage = FirebaseFirestore.instance.collection('Products-Storage');

    _reference = FirebaseFirestore.instance.collection('Products-Storage');
  }

  Future<void> addItemToStorage(String category, String name, String id,
      ProductModel product, BuildContext context) async {
    try {
      if (_productStorage != null) {
        DocumentReference categoryDoc = _productStorage!.doc(category);

        // Fetch the existing document
        DocumentSnapshot ds = await categoryDoc.get();

        List<ProductModel> products = [];

        // If the document exists, get the existing products
        if (ds.exists && ds.data() != null) {
          SingleCategoryModel categoryModel =
              SingleCategoryModel.fromJson(ds.data()! as Map<String, dynamic>);
          if (categoryModel.products != null) {
            products = categoryModel.products!;
          }
        }

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
            ))
            .then((val) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.themeColor,
              content: Text("Added Successfully",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  )),
            ),
          );
        });
      }
    } catch (e) {
      Vx.log("Error while adding item to storage: ${e.toString()}");
    }
  }

  Future<List<ProductModel>> getSingleCategoryProducts(
      {required String category}) async {
    List<ProductModel> catSortProduct = [];
    try {
      DocumentSnapshot? documentSnapshot = await _reference.doc(category).get();

      Object? ob = documentSnapshot.data();
      if (ob != null) {
        SingleCategoryModel categoryModel =
            SingleCategoryModel.fromJson(ob as Map<String, dynamic>);
        if (categoryModel.products != null &&
            categoryModel.products!.isNotEmpty) {

          catSortProduct = categoryModel.products!;
        }
      } else {
        // Vx.log("Item Not Found");
      }
    } catch (e) {
      Vx.log("Error while fetching $category product: ${e.toString()}");
    }

    return catSortProduct;
  }
}
