import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/pages/api_demo_pages/demo_page_api.dart';
import 'package:sheet_demo/pages/api_demo_pages/demo_page_view_model.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class DemoPageApiScreen extends StatefulWidget {
  const DemoPageApiScreen({Key key}) : super(key: key);

  @override
  DemoPageApiScreenState createState() => DemoPageApiScreenState();
}

class DemoPageApiScreenState extends State<DemoPageApiScreen> {
  DemoPageApi demoPageApi = DemoPageApi();
  ScrollController scrollController = ScrollController();
  DemoPageViewModel demoPageViewModel;
  int limit = 8;
  int page = 1;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          demoPageViewModel.demoData.length <= 20) {
        loadData();
      } else if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          demoPageViewModel.demoData.length >= 20) {
        Fluttertoast.showToast(
          msg: 'No more data.!',
          textColor: ColorResource.themeColor,
          backgroundColor: ColorResource.white,
        );
        print('Record over');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    demoPageViewModel ?? (demoPageViewModel = DemoPageViewModel(this));
    return Scaffold(
      appBar: commonAppbar(text: 'Api Pagination'),
      body: demoPageViewModel.demoData == null ||
              demoPageViewModel.demoData.length == 0
          ? Center(child: commonIndicator())
          : Container(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: demoPageViewModel.demoData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == demoPageViewModel.demoData.length - 1 &&
                        demoPageViewModel.demoData.length <= 20) {
                      return Center(child: commonIndicator());
                    }
                    return Padding(
                      padding: EdgeInsets.all(height * 0.01),
                      child: Container(
                        margin: EdgeInsets.all(height * 0.015),
                        decoration: BoxDecoration(
                            color: ColorResource.themeColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(height * 0.013),
                              child: commonText(
                                  text:
                                      "${CommonStrings.id} ${demoPageViewModel.demoData[index].id}",
                                  color: ColorResource.white),
                            ),
                            Container(
                              margin: EdgeInsets.all(height * 0.013),
                              child: commonText(
                                  text:
                                      "${CommonStrings.author} ${demoPageViewModel.demoData[index].author}",
                                  color: ColorResource.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  Future loadData() async {
    print('loading data');
    demoPageViewModel.paginationAPI(limit: limit + 5, page: 1);
    limit = limit + 5;
    setState(() {});
  }
}
