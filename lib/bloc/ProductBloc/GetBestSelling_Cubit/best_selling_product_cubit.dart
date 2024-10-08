import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetBestSelling_Cubit/best_selling_product_state.dart';
import 'package:myshop/services/ProductServices/product_service.dart';

class BestSellingProductCubit extends Cubit<BestSellingProductState> {
  final ProductService _productService = ProductService();

  BestSellingProductCubit() : super(BestSellingProductInitialState()) {
    getBestSellingProducts();
  }

  void getBestSellingProducts() async {
       if (state is BestSellingProductLoadingState || state is BestSellingProductLoadedState) return;
    try {
      emit(BestSellingProductLoadingState());
      List<ProductModel> bestSellingProducts =
          await _productService.getBestSelling();
      if (bestSellingProducts.isEmpty) {
        emit(BestSellingProductErrorState("Products not found."));
      }

      emit(BestSellingProductLoadedState(bestSellingProducts));
    } catch (e) {
      emit(BestSellingProductLoadingState());
    }
  }
}
