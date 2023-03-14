import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';

Widget commonAccountRow({String text, String buttonText, Function function}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(
          color: ColorResource.white,
        ),
      ),
      SizedBox(
        width: 5,
      ),
      InkWell(
          onTap: () {
            function();
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: 1, // Space between underline and text
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: ColorResource.white,
              width: 1.0, // Underline thickness
            ))),
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorResource.white,
              ),
            ),
          ))
    ],
  );
}
