import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/sqlite_database/add_product_list_page.dart';
import 'package:sheet_demo/pages/sqlite_database/add_product_page.dart';
import 'package:sheet_demo/pages/sqlite_database/database/home_presenter.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/user.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ShowProductPage extends StatefulWidget {
  const ShowProductPage({Key key}) : super(key: key);

  @override
  _ShowProductPageState createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage>
    implements HomeContract {
  HomePresenter homePresenter;

  @override
  void initState() {
    super.initState();
    homePresenter = HomePresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).productPageAppbar),
      body: FutureBuilder<List<User>>(
        future: homePresenter.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? AddProductListPage(data, homePresenter)
              : Center(child: commonIndicator());
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.03),
        child: FloatingActionButton(
          onPressed: () async {
            isEdit = false;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProductPage()));
          },
          elevation: 0,
          backgroundColor: ColorResource.themeColor,
          child: Icon(
            Icons.add,
            color: ColorResource.white,
          ),
        ),
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
