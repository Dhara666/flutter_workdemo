import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';

Widget commonCircleAvatar(Uint8List image) {
  return CircleAvatar(
    backgroundColor:  ColorResource.white,
    radius: 33,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
          backgroundColor:  ColorResource.themeColor,
          radius: 30,
          child: Image.memory(
            image,
            fit: BoxFit.cover,
            height: 60,
            width: 60,
          )),
    ),
  );
}
