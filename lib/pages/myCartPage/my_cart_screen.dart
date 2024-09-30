import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/services/CartServices/cart_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/global/cart_item_card.dart';
import 'package:velocity_x/velocity_x.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<ProductModel> cartProducts = [];
  CartServices _cartServices = CartServices();

  @override
  void initState() {
    getAllCartProducts();
    super.initState();
  }

  void getAllCartProducts() async {
    cartProducts = await _cartServices.getCartProduct();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          "Cart 🛒",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: cartProducts.length,
          itemBuilder: (_, index) {
            ProductModel product = cartProducts[index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ItemDetailPage(product: product)));
                  },
                  child: Dismissible(
                    onDismissed: (direction) async{
                      if(product.id != null) await _cartServices.deleteCartProduct(product.id!);

                      setState(() {
                        cartProducts.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${product.name} Removed from cart')));
                    },
                    key: Key(product.id ?? "123"),
                    background: Container(
                        padding: const EdgeInsets.all(12),
                        color: AppColors.themeColor,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                            size: 32,
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
                                color: Color.fromARGB(255, 235, 232, 232)))),
                  )
              ],
            );
          }),
    );
  }
}
