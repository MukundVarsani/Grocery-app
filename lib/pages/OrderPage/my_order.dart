import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:myshop/Model/order_model.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/OrderPage/order_item_card.dart';
import 'package:myshop/services/OrderServices/order_services.dart';
import 'package:myshop/utils/colors.dart';


class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  
  @override
  
  MyOrderState createState() => MyOrderState();
}

class MyOrderState extends State<MyOrder> {
  int activeStep = 0; // Current active step index
  List<ProductModel> myProducts = [];
  OrderModel? myOrder;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMyOrder();
  }

  Future<void> getMyOrder() async {
    // Fetch the order and update the state
    myOrder = await OrderServices().getOrder();
    if (myOrder != null && myOrder?.products != null) {
      myProducts = myOrder!.products!;
      setActiveStep(myOrder!.orderStatus ?? '4');
    }
    // Set loading to false once data is fetched
    setState(() {
      isLoading = false;
    });
  }

  void setActiveStep(String status) {
    switch (status) {
      case "1":
        activeStep = 1;
        break;
      case "2":
        activeStep = 2;
        break;
      case "3":
        activeStep = 3;
        break;

      default:
        activeStep = 4;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: const Text(
          'My Order',
          style: TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : myProducts.isEmpty
              ? const Center(
                  child:
                      Text('No products found')) // Show message if no products
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 6, top: 12, bottom: 12),
                        child: Row(
                          children: [
                            const Text(
                              "Order id: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              myOrder?.id.toString() ?? "NA",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: myProducts.length,
                        itemBuilder: (_, i) {
                          return OrderItemCard(
                            quant: myProducts[i].stock ?? "0",
                            price: myProducts[i].price ?? "0",
                            name: myProducts[i].name ?? "NA",
                            imageUrl: myProducts[i].imageUrl ?? "NA",
                          );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Total Rs: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          Text("₹ ${myOrder?.totalAmount ?? "NA"}/-",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          const Text("Total item: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400)),
                          Text(myProducts.length.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Text(
                              "Order \nplaced",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            "out of \ndelivery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Order \nDelivered",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Order \nCancelled",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      EasyStepper(
                        activeStep: activeStep,
                        stepShape: StepShape.rRectangle,
                        stepBorderRadius: 15,
                        borderThickness: 2,
                        finishedStepBackgroundColor: AppColors.themeColor,
                        finishedStepIconColor: AppColors.whiteColor,
                        activeStepBorderColor:
                            const Color.fromARGB(255, 91, 216, 127),
                        activeStepIconColor:
                            const Color.fromARGB(255, 91, 216, 127),
                        unreachedStepBorderColor: AppColors.greyColor,
                        unreachedStepIconColor: AppColors.greyColor,
                        showLoadingAnimation: false,
                        disableScroll: true,
                        fitWidth: true,
                        internalPadding: 10,
                        lineStyle: const LineStyle(
                          finishedLineColor: AppColors.themeColor,
                          lineThickness: 2,
                          lineSpace: 3,
                          lineType: LineType.normal,
                          unreachedLineColor: AppColors.greyColor,
                          activeLineColor: AppColors.themeColor,
                        ),
                        enableStepTapping: false,
                        steps: const [
                          EasyStep(
                            icon: Icon(
                              Icons.check_circle,
                            ),
                            finishIcon: Icon(Icons.check_sharp),
                          ),
                          EasyStep(
                            icon: Icon(
                              Icons.local_shipping,
                            ),
                            finishIcon: Icon(Icons.check_sharp),
                          ),
                          EasyStep(
                            icon: Icon(
                              Icons.home,
                            ),
                            finishIcon: Icon(Icons.check_sharp),
                          ),
                          EasyStep(
                            icon: Icon(
                              Icons.cancel,
                            ),
                            finishIcon: Icon(Icons.check_sharp),
                          ),
                        ],
                        onStepReached: (index) {
                          setState(() {
                            activeStep = index;
                          });
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
