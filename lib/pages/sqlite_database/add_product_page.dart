import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_textFormFiled.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/database_helper.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/user.dart';
import 'package:sheet_demo/pages/sqlite_database/show_product_page.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:sheet_demo/utils/validation.dart';
import 'package:toast/toast.dart';

class AddProductPage extends StatefulWidget {
  final String productPrice, productTax, productName, productDiscount;
  final int id;
  final Uint8List productPicture;

  AddProductPage(
      {this.productPrice,
      this.productTax,
      this.productName,
      this.id,
      this.productDiscount,
      this.productPicture});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

bool isEdit = false;

class _AddProductPageState extends State<AddProductPage> {
  File imageFile;
  final picker = ImagePicker();

  Future getImageGallery() async {
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    } else {
      print('No Image Selected');
    }
  }

  Future getImageCamera() async {
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    } else {
      print('No Image Selected');
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productTaxController = TextEditingController();
  double subTotal = 0;

  @override
  void initState() {
    if (isEdit == true) {
      productNameController.text = widget.productName.toString();
      productPriceController.text = widget.productPrice.toString();
      productTaxController.text = widget.productTax.toString();
      productDiscountController.text = widget.productDiscount.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
          text: isEdit == true
              ? S.of(context).editProductAppbar
              : S.of(context).addProductAppbar),
      body: Form(
        key: formKey,
        child: Container(
          height: height * 1,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              ColorResource.themeColor.withOpacity(0.2),
              ColorResource.themeColor.withOpacity(0.2)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: height * 0.65,
                      width: width * 0.85,
                      decoration: BoxDecoration(
                          color: ColorResource.themeColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: height * 0.022, top: height * 0.01),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundColor: ColorResource.white,
                                radius: 33,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                            child: Text(
                                              "Select Image Source..",
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          content: Container(
                                            height: height * 0.15,
                                            child: Column(
                                              children: [
                                                commonMaterialButton(
                                                    text: 'camera',
                                                    function: () {
                                                      getImageCamera();
                                                      Navigator.pop(context);
                                                    }),
                                                commonMaterialButton(
                                                    text: 'Gallery',
                                                    function: () {
                                                      getImageGallery();
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: ColorResource.themeColor,
                                    radius: 31,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child: (isEdit == false)
                                            ? ((imageFile != null)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    child: Image.file(
                                                      imageFile,
                                                      width: width * 0.2,
                                                      height: height * 0.2,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.image,
                                                    color: ColorResource.white,
                                                  ))
                                            : imageFile != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    child: Image.file(
                                                      imageFile,
                                                      width: width * 0.2,
                                                      height: height * 0.2,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    child: Image.memory(
                                                      widget.productPicture,
                                                      key: ValueKey(widget
                                                          .productPicture),
                                                      width: width * 0.2,
                                                      height: height * 0.2,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          commonTextFormFiled(
                              labelText: CommonStrings.enterName,
                              controller: productNameController,
                              validator: (val) => validateName(val, context),
                              function: () {}),
                          commonTextFormFiled(
                              labelText: CommonStrings.enterPrice,
                              controller: productPriceController,
                              type: TextInputType.number,
                              validator: (val) => validatePrice(val, context),
                              function: () {}),
                          commonTextFormFiled(
                              labelText: CommonStrings.enterDiscount,
                              type: TextInputType.number,
                              controller: productDiscountController,
                              validator: (val) =>
                                  validateDiscount(val, context),
                              function: () {}),
                          commonTextFormFiled(
                              labelText: CommonStrings.enterTax,
                              type: TextInputType.number,
                              controller: productTaxController,
                              validator: (val) => validateTax(val, context),
                              function: () {}),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.61,
                        left: width * 0.25,
                      ),
                      child: commonMaterialButton(
                          text: isEdit == true
                              ? CommonStrings.buttonEditProduct
                              : CommonStrings.buttonAddProduct,
                          function: () {
                            if (formKey.currentState.validate()) {
                              if (isEdit && widget.productPicture != null) {
                                Toast.show(
                                    isEdit
                                        ? "product Edit Successfully"
                                        : "product Added Successfully",
                                    context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 5);
                                addRecord(isEdit);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowProductPage()));
                              } else if (isEdit == false && imageFile != null) {
                                Toast.show(
                                    isEdit
                                        ? "product Edit Successfully"
                                        : "product Added Successfully",
                                    context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 5);
                                addRecord(isEdit);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowProductPage()));
                              }
                            }
                            if (isEdit) {
                              if (widget.productPicture == null) {
                                Toast.show(
                                    ErrorString.pleaseSelectImage, context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 5);
                              }
                            } else {
                              if (imageFile == null) {
                                Toast.show(
                                    ErrorString.pleaseSelectImage, context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 5);
                              }
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addRecord(bool isEdit) async {
    var db = DatabaseHelper();

    subTotal = (double.parse(productPriceController.text) -
            double.parse(productDiscountController.text)) +
        (double.parse(productPriceController.text) *
            double.parse(productTaxController.text) /
            100);

    print(double.parse(productPriceController.text) -
        double.parse(productDiscountController.text));
    print(double.parse(productPriceController.text) *
        double.parse(productTaxController.text) /
        100);
    print('sub total --> $subTotal');
    var user = User(
      productNameController.text,
      productPriceController.text,
      productDiscountController.text,
      productTaxController.text,
      (isEdit && imageFile == null)
          ? widget.productPicture
          : imageFile.readAsBytesSync(),
      subTotal.toString(),
    );

    if (isEdit) {
      //print("wid" + widget.id.toString());
      user.setUserId(widget.id);
      await db.update(user);
    } else {
      await db.saveUser(user);
    }
  }
}
