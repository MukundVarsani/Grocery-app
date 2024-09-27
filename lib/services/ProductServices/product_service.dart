import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/single_category_model.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductService{
late CollectionReference _productStorage;
  ProductService()
   : _productStorage =

            FirebaseFirestore.instance.collection('Products-Storage');

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