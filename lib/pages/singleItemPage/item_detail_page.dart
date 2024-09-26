import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/widgets/features/item_info_card.dart';
import 'package:myshop/widgets/global/button.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  static const List<List<String>> itemInfo = [
    [AppImages.lotus, "100%", "Organic"],
    [AppImages.calender, "1 Year", "Expiration"],
    [AppImages.rating, "4.8", "Reviews"],
    [AppImages.calories, "80 Kcal", "100 Gram"],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 70,
        backgroundColor: AppColors.lightModeCardColor,
        leading: Container(
          margin: const EdgeInsets.only(left: 20),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
                 Navigator.pop(context)
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            height: 300,
            child: ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: AppColors.lightModeCardColor,
                child: Center(
                  child: SizedBox(
                      height: 224,
                      width: 249,
                      child:
                          Image.asset(AppImages.brocolli, fit: BoxFit.contain)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Arabic Ginger",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(
                      width: 116,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                  color: AppColors.lightModeCardColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.remove),
                                color: AppColors.greyColor,
                                iconSize: 20,
                              )),
                          const Text(
                            "4",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  color: AppColors.themeColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                color: AppColors.whiteColor,
                                iconSize: 20,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "1Kg, 4\$",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 250,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 163 / 67,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10),
                        itemCount: itemInfo.length,
                        itemBuilder: (_, index) => ItemInfoCard(
                              infoImage: itemInfo[index][0],
                              infoValue: itemInfo[index][1],
                              infoDesc: itemInfo[index][2],
                            )))
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 360,
        height: 53,
        child: PrimaryButton(
          title: "Add to cart", onPressed: () {}),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
