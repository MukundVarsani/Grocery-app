import 'package:myshop/Model/product_model.dart';

abstract class BestSellingProductState {}

class BestSellingProductInitialState extends BestSellingProductState {}

class BestSellingProductLoadingState extends BestSellingProductState {}

class BestSellingProductLoadedState extends BestSellingProductState {
  final List<ProductModel> products;
  BestSellingProductLoadedState(this.products);
}

class BestSellingProductErrorState extends BestSellingProductState {
  final String error;
  BestSellingProductErrorState(this.error);
}
