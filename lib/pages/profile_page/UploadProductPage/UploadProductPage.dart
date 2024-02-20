import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/utils.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key, this.product});

  final Product? product;

  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<XFile>? _imageFiles;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  final List<String> _selectedCategories = [];
  final List<String> _categories = [
    "آشپزخانه",
    "لوازم برقی",
    "لوازم خانه",
    "پوشاک",
    "حمل و نقل",
    "کامپیوتر",
    "مبایل",
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = SizeConfig().getScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پست محصولات',
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    radius(
                      avgDimension(30),
                    ),
                  ),
                ),
                child: _imageFiles == null || _imageFiles!.isEmpty
                    ? const Text('No image selected.')
                    : ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            radius(
                              avgDimension(30),
                            ),
                          ),
                          topLeft: Radius.circular(
                            radius(
                              avgDimension(30),
                            ),
                          ),
                        ),
                        child: Image.file(
                            File(
                              _imageFiles![0].path,
                            ),
                            fit: BoxFit.cover),
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  avgDimension(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFieldWidget(
                            maxLines: 1,
                            controller: _titleController,
                            title: "عنوان یا نام محصول",
                            obscureText: false,
                          ),
                        ),
                        SizedBox(width: avgDimension(8)),
                        Flexible(
                          child: TextFieldWidget(
                            title: "قیمت محصول به افغانی",
                            obscureText: false,
                            maxLines: 1,
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                    TextFieldWidget(
                      title: "آدرس",
                      obscureText: false,
                      maxLines: 1,
                      controller: _addressController,
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                    TextFieldWidget(
                      title: "شماره تماس",
                      obscureText: false,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                    TextFieldWidget(
                      title: "ارائه توضیحات ",
                      obscureText: false,
                      maxLines: 3,
                      controller: _descriptionController,
                    ),
                    SizedBox(
                      height: avgDimension(5),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text('انتخاب تصویر'),
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : _uploadProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor3,
                      fixedSize: Size(
                        screenSize.width * avgDimension(0.4),
                        avgDimension(40),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(avgDimension(15)),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: !isLoading
                        ? Text(
                            'آپلود',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: SpinKitSpinningLines(
                                color: Colors.orange,
                                size: 50.0,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(height: avgDimension(5)),
              const Text(
                'کتگوری محصول خود را مشخص کنید',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(
                height: avgDimension(10),
              ),
              CustomCheckBoxGroup(
                buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
                autoWidth: false,
                enableButtonWrap: true,
                wrapAlignment: WrapAlignment.center,
                unSelectedColor: AppColors.categoryColor,
                buttonLables: _categories,
                buttonValuesList: _categories,
                checkBoxButtonValues: (values) {
                  setState(() {
                    _selectedCategories.clear();
                    _selectedCategories.addAll(
                      values.cast<String>(),
                    );
                  });
                },
                horizontal: false,
                width: 120,
                selectedColor: AppColors.mainColor,
                padding: 5,
                enableShape: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    setState(() {
      _imageFiles = selectedImages;
    });
  }

  Future<void> _uploadProduct() async {
    setState(() {
      isLoading = true;
    });

    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageFiles == null ||
        _imageFiles!.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      String errorMessage = "لطفا فیلدهای زیر را پر کنید: ";
      if (_titleController.text.isEmpty) {
        errorMessage += "عنوان، ";
      }
      if (_priceController.text.isEmpty) {
        errorMessage += "قیمت، ";
      }
      if (_imageFiles == null || _imageFiles!.isEmpty) {
        errorMessage += "تصویر، ";
      }
      if (_phoneController.text.isEmpty) {
        errorMessage += "شماره تلفن، ";
      }
      if (_addressController.text.isEmpty) {
        errorMessage += "آدرس، ";
      }
      if (_descriptionController.text.isEmpty) {
        errorMessage += "توضیحات";
      }
      errorMessage = errorMessage.replaceAll(RegExp(r', $'), '');
      String output = errorMessage;
      Utils().showSnackBar(
        context: context,
        content: output,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<String> imageUrls = [];

    if (_imageFiles != null) {
      for (XFile file in _imageFiles!) {
        File imageFile = File(file.path);
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('product_images/$imageName')
            .putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      images: imageUrls,
      categories: _selectedCategories,
      userId: userId,
      address: _addressController.text,
      phone: _phoneController.text,
      uploadDate: DateTime.now().toIso8601String(),
    );

    await FirebaseFirestore.instance
        .collection('products')
        .add(product.toFirestore());

    setState(() {
      isLoading = false;
    });
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageFiles = null;
    _selectedCategories.clear();
  }
}
