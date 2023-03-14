import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;
  final String appbarText;

  FullPhotoPage({this.url, this.appbarText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: appbarText),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
