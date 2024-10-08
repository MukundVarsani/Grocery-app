import 'package:myshop/Model/product_model.dart';

abstract class GetCatProductState {}


class GetCatProductInitialState extends GetCatProductState{}
class GetCatProductLoadingState extends GetCatProductState{}
class GetCatProductLoadedState extends GetCatProductState{
    final List<ProductModel> products;
  GetCatProductLoadedState(this.products);
}
class GetCatProductErrorState extends GetCatProductState{
    final String error;
  GetCatProductErrorState(this.error);
}