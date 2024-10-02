import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/Admin/Pages/User_Order/order_tile.dart';
import 'package:myshop/Admin/Pages/User_Order/user_order_page.dart';
import 'package:myshop/Admin/Services/admin_order_service.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/utils/colors.dart';

class AllUserOrderPage extends StatefulWidget {
  const AllUserOrderPage({super.key});

  @override
  State<AllUserOrderPage> createState() => _AllUserOrderPageState();
}

class _AllUserOrderPageState extends State<AllUserOrderPage> {
  List<OrderModel> allOrders = [];

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
          title: const Text(
            "All Orders",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: AppColors.whiteColor),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
            padding:EdgeInsets.symmetric(vertical: 16) ,
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
