import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/CartBloc/cart_cubit.dart';
import 'package:myshop/bloc/CartBloc/cart_state.dart';
import 'package:myshop/pages/Payment/payment_screen.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/pages/user_navigation_bar.dart';
import 'package:myshop/services/CartServices/cart_services.dart';
import 'package:myshop/services/OrderServices/order_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:myshop/widgets/global/cart_item_card.dart';
import 'package:velocity_x/velocity_x.dart';

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
    super.initState();
  }

  void removeItemFromCart(int index, String id, String name) async {
    try {
      await _cartServices.deleteCartProduct(id);
      VxToast.show(context, msg: '$name Removed from cart');
      setState(() {
        cartProducts.removeAt(index);
      });
    } catch (e) {
      Vx.log("Error while removing item from cart ${e.toString()}");
    }
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
                "Cart",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.whiteColor),
              ),
              Icon(
                Icons.shopping_cart,
                color: AppColors.whiteColor,
              )
            ],
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CartCubit, CartState>(builder: (_, state) {
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColors.whiteColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeColor),
              ),
            );
          }

          if (state is CartLoadedState) {
            List<ProductModel> cartProducts = state.cartProducts;

            total = cartProducts.fold(0, (sum, product) {
              return sum +
                  (int.parse(product.price!) * int.parse(product.stock!));
            });
            return Column(
              children: [
                ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
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
                              onDismissed: (direction) => removeItemFromCart(
                                  index, product.id!, product.name!),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                      onOrderComplete: () {},
                                      orderProducts: cartProducts,
                                      total: total.toString(),
                                    )));
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }

          if (state is CartErrorState) {
            if (state.error == "Empty") {
              SizedBox(
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
              );
            }
            return const Center(
              child: Text(
                "Error while geting cart products",
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.themeColor,
                    fontWeight: FontWeight.w500),
              ),
            );
          }

          return const Center(
            child: Text(
              "Error while geting cart products",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.themeColor,
                  fontWeight: FontWeight.w500),
            ),
          );
        }));
  }
}
