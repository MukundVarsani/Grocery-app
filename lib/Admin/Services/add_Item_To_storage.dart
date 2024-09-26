import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminService {
  CollectionReference? _productStorage;
  AdminService() {
    _productStorage = FirebaseFirestore.instance.collection('Products-Storage');
  }

  Future<void> addItemToStorage(String category, String name, String id,
      Map<String, dynamic> product, BuildContext context) async {
    try {
      Vx.log(_productStorage?.path);

      if (_productStorage != null) {
        DocumentReference categoryDoc = _productStorage!.doc(category);
        DocumentReference itemDoc = categoryDoc.collection(name).doc(id);

        await itemDoc.set(product).then((val) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.themeColor,
              content: Text(" Added Succesfully ",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  )),
            ),
          );
        });
      }
    } catch (e) {
      Vx.log("Error while Adding Item to Cart ${e.toString()}");
    }
  }
}

class $ {}
