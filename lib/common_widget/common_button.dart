import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/utils/size_utils.dart';

Widget commonMaterialButton({String text, Color color, Color textColor, Function function}) {
  return MaterialButton(
      onPressed: () {
        function();
      },
      color: color ?? ColorResource.themeColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide(color: textColor ?? ColorResource.white)),
      child: Text(
        text,
        style: TextStyle(color: textColor ?? ColorResource.white),
      ));
}

Widget commonIconButton({IconData icon, Function function}) {
  return IconButton(
      onPressed: () {
        function();
      },
      icon: Icon(
        icon,
        color: Color(0xffc79ebc),
      ));
}

Widget commonAccountButton({String text, String image, Function function}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: width * 0.12, vertical: height * 0.02),
    child: MaterialButton(
      color: ColorResource.themeColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), side: BorderSide(color:  ColorResource.white)),
      onPressed: () {
        function();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            color: ColorResource.white,
            height: 20,
          ),
          Text(
            text,
            style: TextStyle(color: ColorResource.white, fontSize: 15),
          ),
        ],
      ),
    ),
  );
}
