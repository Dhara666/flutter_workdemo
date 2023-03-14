import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/api_demo_pages/demo_page_api.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api_view_model.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ProviderApiDemo extends StatefulWidget {
  const ProviderApiDemo({Key key}) : super(key: key);

  @override
  ProviderApiDemoState createState() => ProviderApiDemoState();
}

class ProviderApiDemoState extends State<ProviderApiDemo> {
  DemoPageApi demoPageApi = DemoPageApi();
  // ScrollController scrollController = ScrollController();
  ProviderViewModel providerViewModel;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    providerViewModel ?? (providerViewModel = ProviderViewModel(this));
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).providerPageAppbar),
      body: providerViewModel.providerData == null ||
              providerViewModel.providerData.length == 0
          ? Center(
              child:  commonIndicator()
            )
          : ChangeNotifierProvider<ProviderPageApi>(
              create: (BuildContext context) {
                return ProviderPageApi();
              },
              child: Container(
                child: ListView.builder(
                    // controller: scrollController,
                    itemCount: providerViewModel.providerData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(height * 0.01),
                        child: Container(
                          margin: EdgeInsets.all(height * 0.015),
                          decoration: BoxDecoration(
                              color:  ColorResource.themeColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(height * 0.013),
                                child: commonText(
                                    text:
                                        "${CommonStrings.id} ${providerViewModel.providerData[index].id}",
                                    color: ColorResource.white),
                              ),
                              Container(
                                margin: EdgeInsets.all(height * 0.013),
                                child: commonText(
                                    text:
                                        "${CommonStrings.author} ${providerViewModel.providerData[index].author}",
                                    color: ColorResource.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
