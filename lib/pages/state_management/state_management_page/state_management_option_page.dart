import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc_api_demo_page.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api_page_demo.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class StateManagementOptionPage extends StatefulWidget {
  const StateManagementOptionPage({Key key}) : super(key: key);

  @override
  _StateManagementOptionPageState createState() =>
      _StateManagementOptionPageState();
}

class _StateManagementOptionPageState extends State<StateManagementOptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: 'State Management'),
      body: Center(
        child: Container(
          height: height * 0.3,
          width: width * 0.8,
          decoration: BoxDecoration(
              color: ColorResource.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorResource.themeColor, width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              commonMaterialButton(
                  text: 'Provider',
                  color: ColorResource.white,
                  textColor: ColorResource.themeColor,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProviderApiDemo()));
                  }),
              commonMaterialButton(
                  text: 'Bloc',
                  color: ColorResource.white,
                  textColor: ColorResource.themeColor,
                  function: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BlocApiDemo()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
