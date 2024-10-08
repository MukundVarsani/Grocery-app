import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetAllProducts_Cubit/get_all_products_state.dart';
import 'package:myshop/services/ProductServices/product_service.dart';

class GetAllProductsCubit extends Cubit<GetAllProductsState> {
  final ProductService _productService = ProductService();


  GetAllProductsCubit() : super(GetAllProductsInitialState()) {
    getAllProducts();
  }


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
