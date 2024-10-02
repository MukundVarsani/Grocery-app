import 'package:flutter/material.dart';

import 'package:myshop/Admin/Pages/User_Order/order_tile.dart';
import 'package:myshop/Admin/Pages/User_Order/user_order_page.dart';
import 'package:myshop/Admin/Services/admin_order_service.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AllUserOrderPage extends StatefulWidget {
  const AllUserOrderPage({super.key});

  @override
  State<AllUserOrderPage> createState() => _AllUserOrderPageState();
}

class _AllUserOrderPageState extends State<AllUserOrderPage> {
  List<OrderModel> allOrders = [];
  bool isSearching = false;

  @override
  void initState() {
    getUserOrdersList();
    super.initState();
  }

  void getUserOrdersList() async {
    allOrders = await AdminOrderService().getAllOrder();
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
              icon:  Icon(
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
                        // List<ProductModel> filtered =
                        //     allProducts.where((product) {
                        //   final productName = product.name?.toLowerCase() ?? '';
                        //   final input = email.toLowerCase();
                        //   return productName.contains(input);
                        // }).toList();
                        setState(() {});
                      },
                      cursorColor: AppColors.themeColor,
                      style: const TextStyle(color: AppColors.themeColor),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return "Email can't be empty";
                        }

                        if (!email.validateEmail()) {
                          return "Invalid Email ";
                        }
                        return null;
                      },
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
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_alt,
                  color: AppColors.whiteColor,
                ))
          ],
          centerTitle: true,
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: allOrders.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UserOrderPage(
                                      userId:
                                          allOrders[index].userId.toString(),
                                    )));
                      },
                      child: OrderTile(
                        orderId: allOrders[index].id.toString(),
                        statusCode: allOrders[index].orderStatus.toString(),
                      )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              );
            }));
  }
}
