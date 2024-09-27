import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/Admin/Services/admin_services.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Resources/Firebase_storage/storage_method.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/utils/pick_image.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class AddItemToCart extends StatefulWidget {
  final String cat;
  const AddItemToCart({super.key, this.cat = ""});

  @override
  State<AddItemToCart> createState() => _AddItemToCartState();
}

class _AddItemToCartState extends State<AddItemToCart> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? itemImageURL;
  bool isPicAdding = false;
  Uint8List? file;

  late final AdminService _adminService;

  String? category;
  final List<String> options = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Meat'
  ];

  @override
  void initState() {
    _adminService = AdminService();
    if (widget.cat.isNotEmptyAndNotNull) {
      category = widget.cat;
    }
    super.initState();
  }

  void addItemImage() async {
    try {
      isPicAdding = true;
      setState(() {});
      Uint8List pic = await pickImage(ImageSource.gallery);
      if (pic.isNotEmpty) file = pic;
      isPicAdding = false;
      setState(() {});
    } catch (e) {
      Vx.log("Error while adding pic $e");
    }
  }

  void addToStorage() async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.themeColor,
          content: Text("Please select an image",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (file != null && file!.isNotEmpty) {
        itemImageURL =
            await StorageMethod().uploadItemImageToCloud(childNames: [
          'ProductImage',
          category!,
          _nameController.text.trim().toString(),
        ], file: file!, context: context);

        setState(() {});
      }

      String productId = const Uuid().v4();

      ProductModel product = ProductModel(
        id: productId,
        category: category,
        description: _descriptionController.text.trim(),
        name: _nameController.text.trim(),
        price: _priceController.text.trim(),
        stock: _stockController.text.trim(),
        imageUrl: itemImageURL,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        isAvailable: true,
      );

      await _adminService.addItemToStorage(
        category!,
        _nameController.text.trim(),
        productId,
        product,
        context,
      );

      _nameController.clear();
      _stockController.clear();
      _priceController.clear();
      _descriptionController.clear();
      file?.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();

    _stockController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightModeCardColor,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        centerTitle: true,
        title: const Text(
          "Add Fruit to cart",
          style: TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: addItemImage,
                          child: Container(
                            height: 200,
                            width: 200,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.themeColor),
                            child: isPicAdding
                                ? const CircularProgressIndicator.adaptive(
                                    backgroundColor: AppColors.whiteColor,
                                  )
                                : (file != null && file!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.memory(
                                          file!,
                                        ))
                                    : Image.asset(
                                        fit: BoxFit.contain,
                                        AppImages.uploadImage,
                                        color: AppColors.whiteColor,
                                      ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Name",
                        style: TextStyle(
                            color: Color.fromARGB(255, 15, 131, 47),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      VxTextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        fillColor: Colors.transparent,
                        borderColor: const Color.fromARGB(255, 15, 131, 47),
                        borderType: VxTextFieldBorderType.roundLine,
                        borderRadius: 10,
                        style: const TextStyle(
                          color: AppColors.themeColor,
                        ),
                        cursorColor: AppColors.themeColor,
                        prefixIcon: const Icon(
                          Icons.add_box,
                          color: Color.fromARGB(255, 15, 131, 47),
                          size: 20,
                        ),
                        onChanged: (name) {
                          if (name.isNotEmptyAndNotNull) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: (name) {
                          if (name.isEmptyOrNull) {
                            return "Fill Name Field";
                          }
                          return null;
                        },
                      ),
                      const HeightBox(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 131, 47),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 170,
                                child: VxTextField(
                                  keyboardType: TextInputType.number,
                                  controller: _stockController,
                                  fillColor: Colors.transparent,
                                  borderColor:
                                      const Color.fromARGB(255, 15, 131, 47),
                                  borderType: VxTextFieldBorderType.roundLine,
                                  borderRadius: 10,
                                  style: const TextStyle(
                                    color: AppColors.themeColor,
                                  ),
                                  cursorColor: AppColors.themeColor,
                                  prefixIcon: const Icon(
                                    Icons.numbers_sharp,
                                    size: 20,
                                    color: Color.fromARGB(255, 15, 131, 47),
                                  ),
                                  onChanged: (q) {
                                    if (q.isNotEmpty) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  validator: (quantity) {
                                    if (quantity.isEmptyOrNull) {
                                      return "Fill Quantity Field";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 131, 47),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 170,
                                child: VxTextField(
                                  keyboardType: TextInputType.number,
                                  controller: _priceController,
                                  fillColor: Colors.transparent,
                                  borderColor:
                                      const Color.fromARGB(255, 15, 131, 47),
                                  borderType: VxTextFieldBorderType.roundLine,
                                  borderRadius: 10,
                                  style: const TextStyle(
                                    color: AppColors.themeColor,
                                  ),
                                  cursorColor: AppColors.themeColor,
                                  prefixIcon: const Icon(
                                    Icons.currency_rupee_outlined,
                                    size: 20,
                                    color: Color.fromARGB(255, 15, 131, 47),
                                  ),
                                  onChanged: (p) {
                                    if (p.isNotEmpty) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  validator: (price) {
                                    if (price.isEmptyOrNull) {
                                      return "Fill Price field";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const HeightBox(15),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 15, 131, 47),
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(
                              color: AppColors.themeColor,
                              fontWeight: FontWeight.w500),
                          hint: const Text(
                            'Select an Category',
                            style: TextStyle(color: AppColors.themeColor),
                          ),
                          value: category,
                          items: options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          iconEnabledColor:
                              const Color.fromARGB(255, 15, 131, 47),
                          onChanged: (String? newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                        ),
                      ),
                      const HeightBox(15),
                      const Text(
                        "Description",
                        style: TextStyle(
                            color: Color.fromARGB(255, 15, 131, 47),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const HeightBox(8),
                      VxTextField(
                        maxLine: 4,
                        controller: _descriptionController,
                        fillColor: Colors.transparent,
                        borderColor: const Color.fromARGB(255, 15, 131, 47),
                        borderType: VxTextFieldBorderType.roundLine,
                        borderRadius: 10,
                        style: const TextStyle(
                          color: AppColors.themeColor,
                        ),
                        cursorColor: AppColors.themeColor,
                        prefixIcon: const Icon(
                          Icons.description,
                          size: 20,
                          color: Color.fromARGB(255, 15, 131, 47),
                        ),
                        suffixColor: AppColors.themeColor,
                        validator: (description) {
                          if (description!.isEmpty) {
                            return "Fill Description field";
                          }
                          return null;
                        },
                        onChanged: (d) {
                          if (d.isNotEmpty) {
                            _formKey.currentState!.validate();
                          }
                        },
                      ),
                      const HeightBox(15),
                      PrimaryButton(
                          title: "Add Item to Storage",
                          isLoading: false,
                          onPressed: addToStorage),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
