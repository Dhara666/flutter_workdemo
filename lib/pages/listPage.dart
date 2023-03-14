import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';

// ignore: must_be_immutable
class ListPage extends StatefulWidget {
  String label;
  Color color;

  ListPage({this.label, this.color});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.label),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black)),
            child: Center(
                child: Text(
              widget.label,
              style: TextStyle(color:  ColorResource.white),
            )),
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          )
        ],
      ),
    );
  }
}
