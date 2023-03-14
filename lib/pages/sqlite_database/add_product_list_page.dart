import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_circleavatar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/pages/sqlite_database/add_product_page.dart';
import 'package:sheet_demo/pages/sqlite_database/database/home_presenter.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/user.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class AddProductListPage extends StatefulWidget {
  final List<User> country;
  final HomePresenter homePresenter;

  AddProductListPage(
    this.country,
    this.homePresenter, {
    Key key,
  });

  @override
  _AddProductListPageState createState() => _AddProductListPageState();
}

class _AddProductListPageState extends State<AddProductListPage> implements HomeContract {
  HomePresenter homePresenter;
  bool iconFavourite = false;

  @override
  initState() {
    super.initState();
    homePresenter = HomePresenter(this);
    refresh();
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.country == null ? 0 : widget.country.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.02, vertical: height * 0.01),
                  child: Container(
                      decoration:
                          BoxDecoration(color:  ColorResource.themeColor, borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            child: Column(
                              children: [
                                commonCircleAvatar(widget.country[index].productPicture),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  commonHeightBox(heightBox: 7),
                                  commonText(text: widget.country[index].productName, color: ColorResource.white),
                                  commonText(
                                      text:
                                          CommonStrings.price + widget.country[index].productPrice,
                                      color:  ColorResource.white),
                                  commonText(
                                      text: CommonStrings.discount +
                                          widget.country[index].productDiscount +
                                          " ₹",
                                      color:  ColorResource.white),
                                  commonText(
                                      text: CommonStrings.tax +
                                          widget.country[index].productTax +
                                          "%",
                                      color:  ColorResource.white),
                                  commonText(
                                      text: CommonStrings.totalPrice +
                                          widget.country[index].productSubTotal,
                                      color:  ColorResource.white),
                                  commonHeightBox(heightBox: 5),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: ColorResource.white),
                                onPressed: () async {
                                  isEdit = true;
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddProductPage(
                                                id: widget.country[index].id,
                                                productName: widget.country[index].productName,
                                                productPrice: widget.country[index].productPrice,
                                                productTax: widget.country[index].productTax,
                                                productDiscount:
                                                    widget.country[index].productDiscount,
                                                productPicture:
                                                    widget.country[index].productPicture,
                                              ))).then((value) => setState(() {
                                        refresh();
                                      }));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever, color: ColorResource.white),
                                onPressed: () => widget.homePresenter.delete(widget.country[index]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(left: height * 0.02)),
                );
              }),
          SizedBox(height: height * 0.22),
        ],
      ),
    );
  }

  int i;
  var results;

  refresh() {
    results = homePresenter.getUser();
    setState(() {});
    // print("value ====>" + results.toString());
    return results;
  }
}
