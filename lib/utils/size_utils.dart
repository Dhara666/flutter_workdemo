import 'package:flutter/material.dart';

double height = 0;
double width = 0;

size(context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
}

// print("height => ${MediaQuery.of(context).size.height * 0.008}"); 5
// print("height => ${MediaQuery.of(context).size.height * 0.016}"); 10
// print("height => ${MediaQuery.of(context).size.height * 0.0235}"); 15
// print("height => ${MediaQuery.of(context).size.height * 0.032}"); 20
// print("height => ${MediaQuery.of(context).size.height * 0.04}"); 25
// print("height => ${MediaQuery.of(context).size.height * 0.044}"); 28
// print("height => ${MediaQuery.of(context).size.height * 0.047}"); 30
