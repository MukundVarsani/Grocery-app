import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/pages/user_navigation_bar.dart';
import 'package:myshop/services/CartServices/cart_services.dart';
import 'package:myshop/services/OrderServices/order_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:myshop/widgets/global/cart_item_card.dart';


class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<ProductModel> cartProducts = [];
  bool isOrdering = false;
  int total = 0;
  final CartServices _cartServices = CartServices();
  final OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    getAllCartProducts();
    super.initState();
  }

  void getAllCartProducts() async {
    cartProducts = await _cartServices.getCartProduct();

    if (cartProducts.isNotEmpty) {
      for (var product in cartProducts) {
        total = total + (int.parse(product.price!) * int.parse(product.stock!));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        elevation: 0,
       
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cart ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.whiteColor),
            ),

            Icon(Icons.shopping_cart, color: AppColors.whiteColor,)
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const UserNavigationBar(
                                          index: 1,
                                        )));
                          },
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
                    itemCount: cartProducts.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      ProductModel product = cartProducts[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ItemDetailPage(product: product)));
                            },
                            child: Dismissible(
                              onDismissed: (direction) async {
                                if (product.id != null) {
                                  await _cartServices
                                      .deleteCartProduct(product.id!);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: Text(
                                            '${product.name} Removed from cart')));
                                setState(() {
                                  cartProducts.removeAt(index);
                                });
                              },
                              key: Key(product.id ?? "123"),
                              background: Container(
                                  padding: const EdgeInsets.all(12),
                                  color: AppColors.themeColor,
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.whiteColor,
                                        size: 32,
                                      ),
                                    ),
                                  )),
                              direction: DismissDirection.endToStart,
                              child: CartItemCard(
                                imageUrl: product.imageUrl ?? "",
                                quant: product.stock ?? "NA",
                                price: product.price ?? "NO",
                                name: product.name ?? "NA",
                              ),
                            ),
                          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PrimaryButton(
                      isLoading: isOrdering,
                      title: "Place order",
                      onPressed: () async {
                        setState(() {
                          isOrdering = true;
                        });

                        bool isPlaced = await _orderServices.makeOrder(
                            cartProducts, context);
                        setState(() {
                          isOrdering = false;
                        });
                        if (isPlaced) {
                          _cartServices.emptyCart();
                          setState(() {
                            getAllCartProducts();
                          });
                        }
                      }),
                )
              ],
            ),
    );
  }
}
