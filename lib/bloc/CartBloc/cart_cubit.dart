import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/CartBloc/cart_state.dart';
import 'package:myshop/services/CartServices/cart_services.dart';

class CartCubit extends Cubit<CartState> {
  final CartServices _cartServices = CartServices();
  CartCubit() : super(CartInitialState()) {
    getCartProducts();
  }
  void getCartProducts() async {
    try {
      emit(CartLoadingState());

      List<ProductModel> products = await _cartServices.getCartProduct();

      if (products.isEmpty) emit(CartErrorState("Empty"));
      emit(CartLoadedState(products));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }
}
