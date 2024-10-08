import 'package:myshop/Model/product_model.dart';

abstract class GetAllProductsState {}

class GetAllProductsInitialState extends GetAllProductsState {}

class GetAllProductsLoadingState extends GetAllProductsState {}

class GetAllProductsLoadedState extends GetAllProductsState {
  final List<ProductModel> products;
  GetAllProductsLoadedState(this.products);
}

class GetAllProductsErrorState extends GetAllProductsState {
  final String error;
  GetAllProductsErrorState(this.error);
}
