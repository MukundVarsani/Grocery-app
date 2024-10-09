import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Admin/Services/admin_order_service.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/bloc/AllUsersOrderBloc/all_users_orders_state.dart';

class AllUserOrdersCubit extends Cubit<AllUsersOrdersState> {
  final AdminOrderService _adminOrderService = AdminOrderService();
  AllUserOrdersCubit() : super(AllUsersOrderInitialState()) {
    getAllOrders();
  }

  void getAllOrders() async {
    try {
      emit(AllUsersOrderLoadingState());
      List<OrderModel> allUsersOrders = await _adminOrderService.getAllOrder();
      emit(AllUsersOrderLoadedState(allUsersOrders));
    } catch (e) {
      emit(AllUsersOrderErrorState(e.toString()));
    }
  }
}
