import 'package:myshop/Model/order_model.dart';

abstract class AllUsersOrdersState {}

class AllUsersOrderInitialState extends AllUsersOrdersState {}

class AllUsersOrderLoadingState extends AllUsersOrdersState {}

class AllUsersOrderLoadedState extends AllUsersOrdersState {
  List<OrderModel> allUsersOrders;
  AllUsersOrderLoadedState(this.allUsersOrders);
}

class AllUsersOrderErrorState extends AllUsersOrdersState {
  final String error;

  AllUsersOrderErrorState(this.error);
}
