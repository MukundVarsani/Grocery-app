import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetAllProducts_Cubit/get_all_products_state.dart';
import 'package:myshop/services/ProductServices/product_service.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  final ProductService _productService = ProductService();


  GetAllProductsCubit() : super(GetAllProductsInitialState()) {
    getAllProducts();
  }

  // void categoryWiseProduct({required String category}) async {
  //   try {
  //     emit(ProductLoadingState());

  //     List<ProductModel> catProducts =
  //         await _productService.getSingleCategoryProducts(category: category);

  //     if (catProducts.isEmpty) emit(ProductErrorState("Products not found."));

  //     emit(ProductLoadedState(catProducts));
  //   } catch (e) {
  //     emit(ProductErrorState(e.toString()));
  //   }
  // }

  void getAllProducts() async {
    if (state is GetAllProductsLoadingState ||
        state is GetAllProductsLoadedState) return;

    try {
      emit(GetAllProductsLoadingState());

      List<ProductModel> allProducts =
          await _productService.getAllAvailableItems();
      if (  allProducts.isEmpty) {
        emit(GetAllProductsErrorState("Products not found."));
      }

      emit(GetAllProductsLoadedState(allProducts));

    } catch (e) {
      emit(GetAllProductsLoadingState());
    }
   
  }
}
