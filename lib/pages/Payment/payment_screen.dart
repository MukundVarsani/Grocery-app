import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/Add_to_storage/add_Item_to_cat_page.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/pages/user_navigation_bar.dart';
import 'package:myshop/services/CartServices/cart_services.dart';
import 'package:myshop/services/OrderServices/order_services.dart';
import 'package:myshop/services/PaymentServices/payement_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:myshop/widgets/global/cart_item_card.dart';
import 'package:slider_button/slider_button.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentScreen extends StatefulWidget {
  final List<ProductModel> orderProducts;
  final String total;
  final VoidCallback onOrderComplete;
  const PaymentScreen(
      {super.key,
      required this.orderProducts,
      required this.total,
      required this.onOrderComplete});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<ProductModel> cartProducts = [];
  bool isOrdering = false;
  int total = 0;
  final CartServices _cartServices = CartServices();
  final OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    cartProducts = widget.orderProducts;
    super.initState();
    total = int.parse(widget.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        elevation: 0,
        leading: BackButton(
          color: AppColors.whiteColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Payment",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.whiteColor),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.payment,
              color: AppColors.whiteColor,
            )
          ],
        ),
        centerTitle: true,
      ),
      body: cartProducts.isEmpty
          ? SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Is cart Empty? ",
                      style: TextStyle(
                        color: AppColors.themeColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.whiteColor,
                          ))),
                ],
              ),
            )
          : Column(
              children: [
                ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: cartProducts.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      ProductModel product = cartProducts[index];
                      return Column(
                        children: [
                          productCard(
                              product.stock ?? "NA",
                              product.price ?? "NO",
                              product.name ?? "NA",
                              product.imageUrl ?? ""),
                          if (index < cartProducts.length - 1)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10)
                                  .copyWith(top: 5),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 235, 232, 232)))),
                            ),
                        ],
                      );
                    }),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Total Rs: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Text("₹ $total/-",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    const Text("Total item: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    Text(cartProducts.length.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SliderButton(
                    action: () async {
                      bool isSuccessfull =
                          await PayementServices.instance.makePayment(total);

                      Vx.log(isSuccessfull);
                      if (!isSuccessfull) {
                        VxToast.show(context, msg: "Payment Failed");
                        return false;
                      } else {
                        await _orderServices.makeOrder(cartProducts, context);
                        await _cartServices.emptyCart();
                        widget.onOrderComplete();
                        VxToast.show(context, msg: "Order Placed Succesfully");
                        Navigator.pop(context);
                      }
                      return true;
                    },
                    height: 60,
                    buttonSize: 50,
                    width: 300,
                    backgroundColor: AppColors.themeColor,
                    baseColor: AppColors.themeColor,
                    label: const Text("Slide to pay",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        )),
                    icon: const Center(
                        child: Icon(
                      Icons.double_arrow,
                      color: AppColors.themeColor,
                      size: 30.0,
                    )),
                    vibrationFlag: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}

Widget productCard(String quant, String price, String name, String imageUrl) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    height: 62,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(
              imageUrl,
              width: 42,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("1Kg , ₹ $price/-",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(
          width: 12,
        ),
        Column(
          children: [
            const Text(
              "Quantity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(quant,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.red)),
          ],
        ),
      ],
    ),
  );
}
