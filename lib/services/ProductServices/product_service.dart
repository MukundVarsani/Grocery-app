import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/single_category_model.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductService {
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

  // Future<List<ProductModel>> getAllAvailItem() async {
  //   List<ProductModel> allProducts = [];

  //   try {
  //     QuerySnapshot qs = await _productStorage.get();

  //     for (QueryDocumentSnapshot doc in qs.docs) {
  //       Map<String, dynamic> ob = doc.data() as Map<String, dynamic>;

  //       List<dynamic> productsList = ob['products'];

  //       for (int i = 0; i < productsList.length; i++) {
  //         ProductModel pm = ProductModel.fromJson(ob['products'][i]);
  //         allProducts.add(pm);
  //       }
  //     }

  //   } catch (e) {
  //     Vx.log("Error while fetching all item for User: $e");
  //   }

  //   return allProducts;
  // }

  Future<List<ProductModel>> getAllAvailableItems() async {
    List<ProductModel> allProducts = [];

    try {
      QuerySnapshot qs = await _productStorage.get();

      // Map over documents and extract product models
      allProducts = qs.docs.expand((doc) {
        Map<String, dynamic> ob = doc.data() as Map<String, dynamic>;
        List<dynamic> productsList = ob['products'] ?? [];
        return productsList.map((item) => ProductModel.fromJson(item));
      }).toList();
    } catch (e) {
      Vx.log("Error while fetching all items for User: $e");
    }

    return allProducts;
  }

  Future<List<ProductModel>> getBestSelling() async {
    List<ProductModel> allProducts = [];

    try {
      QuerySnapshot qs = await _productStorage.get();

      for (QueryDocumentSnapshot doc in qs.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('products') &&
            data['products'] is List &&
            data['products'].isNotEmpty) {
          ProductModel pm = ProductModel.fromJson(data['products'][0]);
          allProducts.add(pm);
        }
      }
    } catch (e) {
      Vx.log("Error while fetching all item for User: $e");
    }

    return allProducts;
  }
}
