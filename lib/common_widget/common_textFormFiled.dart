import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';

Widget commonTextFormFiled(
    {TextEditingController controller,
    TextInputType type,
    String labelText,
    Function function,
    Function validator}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextFormField(
        onTap: () {
          function();
        },
        cursorColor: ColorResource.white,
        style: TextStyle(color: ColorResource.white),
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: ColorResource.white),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorResource.grey)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorResource.white)),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        ),
        validator: validator),
  );
}

Widget commonMapTextFormFiled(
    {TextEditingController controller,
    String labelText,
    IconData icon,
    Color iconColor,
    FocusNode focusNode,
    Function onSaved,
    Function function}) {
  return Padding(
    padding: EdgeInsets.only(left: 15, right: 15),
    child: TextFormField(
        onTap: () {
          function();
        },
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 12),
          prefixIcon: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        controller: controller,
        focusNode: focusNode,
        onSaved: onSaved),
  );
}
