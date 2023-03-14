import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ImagePermission extends StatefulWidget {
  const ImagePermission({Key key}) : super(key: key);

  @override
  _ImagePermissionState createState() => _ImagePermissionState();
}

class _ImagePermissionState extends State<ImagePermission> {
  var imageUrl =
      "https://cdn.pixabay.com/photo/2018/01/14/23/12/nature-3082832__480.jpg";
  GlobalKey _globalKey = GlobalKey();
  var encodedStr =
      "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";

  Uint8List bytes;

  @override
  void initState() {
    super.initState();
    bytes = base64.decode(encodedStr);
    print(base64.decode(encodedStr));
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    size(context);
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).imagePermissionAppbar),
      body: ListView(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60),
            child: commonMaterialButton(
                text: 'Image Download',
                function: () {
                  _createFileFromString();
                }),
          )
        ],
      ),
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    // _toastInfo(info);
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: ColorResource.themeColor,
        textColor: ColorResource.white);
  }

  _createFileFromString() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/abc.png';
    print("+++=local file full path $fullPath");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);
    final result = await ImageGallerySaver.saveImage(bytes);
    _toastInfo("Image Download SuccessFully");
    print(result);
    return file.path;
  }
}
