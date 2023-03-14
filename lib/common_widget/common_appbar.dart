import 'package:flutter/material.dart';

commonAppbar({String text}) {
  return AppBar(
    title: Text(text),
    leadingWidth: 30,
    elevation: 0,
  );
}
