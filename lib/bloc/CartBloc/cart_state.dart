import 'package:myshop/Model/product_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<ProductModel> cartProducts;

  CartLoadedState(this.cartProducts);
}

class CartErrorState extends CartState {
  final String error;

  CartErrorState(this.error);
}
