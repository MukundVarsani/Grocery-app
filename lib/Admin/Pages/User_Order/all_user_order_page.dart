import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Admin/Pages/User_Order/order_tile.dart';
import 'package:myshop/Admin/Pages/User_Order/user_order_page.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/bloc/AllUsersOrderBloc/all_user_Orders_cubit.dart';
import 'package:myshop/bloc/AllUsersOrderBloc/all_users_orders_state.dart';
import 'package:myshop/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AllUserOrderPage extends StatefulWidget {
  const AllUserOrderPage({super.key});

  @override
  State<AllUserOrderPage> createState() => _AllUserOrderPageState();
}

class _AllUserOrderPageState extends State<AllUserOrderPage> {
  List<OrderModel> allOrders = [];
  List<OrderModel> filteredOrder = [];
  bool isSearching = false;
  int currentFilter = 0;
  List<String> allStatusCode = ["1", "2", "3", "4"];
  List<String> allStatus = [
    "Out of delivery",
    "Order Delivered",
    "Order Canceled",
    "Order Placed"
  ];

  void filterByStatus(int index) {
    final input = allStatusCode[index].toLowerCase();
    List<OrderModel> filtered = allOrders.where((order) {
      final status = order.orderStatus?.toLowerCase() ?? '';

      return status == input;
    }).toList();

    filteredOrder = filtered;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.themeColor,
          leading: IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: AppColors.whiteColor,
              )),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeInBack,
            child: isSearching
                ? Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: VxTextField(
                      clear: false,
                      enableSuggestions: true,
                      fillColor: Colors.white,
                      borderColor: AppColors.whiteColor,
                      borderType: VxTextFieldBorderType.roundLine,
                      borderRadius: 10,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.themeColor,
                      ),
                      onChanged: (email) {
                        setState(() {});
                      },
                      cursorColor: AppColors.themeColor,
                      style: const TextStyle(color: AppColors.themeColor),
                    ),
                  )
                : const Text(
                    "All Orders",
                    key: ValueKey('titleText'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.whiteColor),
                  ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      useSafeArea: true,
                      barrierColor: Colors.transparent,
                      builder: (_) {
                        return Stack(
                          children: [
                            Positioned(
                                right: 5,
                                top: 55,
                                child: Container(
                                  height: 150,
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(5, 5),
                                            blurRadius: 10)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Sort by Status: ",
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                           context.read<AllUserOrdersCubit>().getAllOrders();
                                          currentFilter++;
                                          filterByStatus(currentFilter % 4);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 2),
                                          width: double.infinity,
                                          child: Text(
                                            "${allStatus[currentFilter % 4]} ",
                                            style: const TextStyle(
                                                color: AppColors.themeColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          filteredOrder = allOrders;
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 2),
                                          width: double.infinity,
                                          child: const Text(
                                            "All Order ",
                                            style: TextStyle(
                                                color: AppColors.themeColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),

                                      //
                                    ],
                                  ),
                                ))
                          ],
                        );
                      });
                },
                icon: const Icon(
                  Icons.filter_alt,
                  color: AppColors.whiteColor,
                ))
          ],
          centerTitle: true,
        ),
        body: BlocBuilder<AllUserOrdersCubit, AllUsersOrdersState>(
          builder: (context, state) {
            if (state is AllUsersOrderLoadingState) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.themeColor),
                ),
              );
            } else if (state is AllUsersOrderErrorState) {
              return const Center(
                child: Text(
                  "No Item Found",
                  style: TextStyle(
                      color: AppColors.themeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              );
            } else if (state is AllUsersOrderLoadedState) {
              if (filteredOrder.isEmpty) {
                allOrders = state.allUsersOrders;
                filteredOrder = allOrders;
              }
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: filteredOrder.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserOrderPage(
                                    userId:
                                        filteredOrder[index].userId.toString(),
                                  ),
                                ),
                              );
                            },
                            child: OrderTile(
                              orderId: filteredOrder[index].id.toString(),
                              statusCode:
                                  filteredOrder[index].orderStatus.toString(),
                            )),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  });
            }
            return const Center(
              child: Text(
                "Error while geting product",
                style: TextStyle(
                    color: AppColors.themeColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            );
          },
        ));
  }
}
