// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String category = "";

  String imageUrl =
      "https://media.istockphoto.com/id/184276818/photo/red-apple.jpg?s=612x612&w=0&k=20&c=NvO-bLsG0DJ_7Ii8SSVoKLurzjmV0Qi4eGfn6nW3l5w=";

  String productId = "xx-xx-xx-xx";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isEditing = true;

  @override
  void initState() {
    _nameController.text = widget.product.name ?? "Null";
    _priceController.text = widget.product.price ?? "Null";
    _quantityController.text = widget.product.stock ?? "Null";
    _descriptionController.text = widget.product.description ?? "Null";
    imageUrl = widget.product.imageUrl ?? "Null";
    category = widget.product.category ?? 'Null';
    productId = widget.product.id ?? "Null";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: AppColors.themeColor,
        leading: BackButton(
          color: AppColors.whiteColor,
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          _nameController.text,
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 8),
             Row(children: [
              Text(
                "Product Id:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.themeColor),
              ),
            const SizedBox(width: 5),
              Text(
                productId,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ]),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff23AA49),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    readOnly: isEditing,
                    
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                     
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintStyle: TextStyle(color: AppColors.themeColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.themeColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.themeColor, width: 2),
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.w500),
                    cursorColor: AppColors.themeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      "Price: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff23AA49),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        readOnly: isEditing,
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.themeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(color: AppColors.themeColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.themeColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.themeColor, width: 1),
                          ),
                        ),
                        style: TextStyle(fontWeight: FontWeight.w500),
                        cursorColor: AppColors.themeColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff23AA49),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        readOnly: isEditing,
                        keyboardType: TextInputType.number,
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: AppColors.themeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(color: AppColors.themeColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.themeColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.themeColor, width: 2),
                          ),
                        ),
                        style: TextStyle(fontWeight: FontWeight.w500),
                        cursorColor: AppColors.themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Category
            const SizedBox(height: 25),

            Row(children: [
              Text(
                "Category: ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.themeColor),
              ),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ]),
            const SizedBox(height: 25),

            const Text(
              "Description:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff23AA49),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 6,
              readOnly: isEditing,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: AppColors.themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(color: AppColors.themeColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.themeColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.themeColor, width: 2),
                ),
              ),
              style: TextStyle(fontWeight: FontWeight.w500),
              cursorColor: AppColors.themeColor,
            ),

            SizedBox(
              height: 40,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(
                onPressed: () {
                  if (isEditing) isEditing = false;

                  // isEditing = !isEditing;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeColor,
                    minimumSize: Size(170, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
                child: const Text(
                  "Edit",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!isEditing) isEditing = true;
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeColor,
                    minimumSize: Size(170, 44),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11))),
                child: const Text(
                  "Save",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
