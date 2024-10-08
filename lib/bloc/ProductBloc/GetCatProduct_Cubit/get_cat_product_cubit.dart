import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetCatProduct_Cubit/get_cat_product_state.dart';
import 'package:myshop/services/ProductServices/product_service.dart';

class GetCatProductCubit extends Cubit<GetCatProductState> {
  final ProductService _productService = ProductService();

  GetCatProductCubit() : super(GetCatProductInitialState());

  void categoryWiseProduct({required String category}) async {
    try {
      emit(GetCatProductLoadingState());

      List<ProductModel> catProducts =
          await _productService.getSingleCategoryProducts(category: category);

      if (catProducts.isEmpty) {
        emit(GetCatProductErrorState("Products not found."));
      }

      emit(GetCatProductLoadedState(catProducts));
    } catch (e) {
      emit(GetCatProductErrorState(e.toString()));
    }
  }
}
