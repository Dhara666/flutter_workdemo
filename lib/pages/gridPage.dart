import 'package:flutter/material.dart';
import 'package:sheet_demo/generated/l10n.dart';

// ignore: must_be_immutable
class GridPage extends StatefulWidget {
  String label;
  Color color;

  GridPage({this.label, this.color});

  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).gridDetailsPageAppbar),
        backgroundColor: widget.color,
      ),
      body: ListView(
        children: [
          //Center(child: Text(widget.label)),
          Container(
            decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(
              widget.label,
              style: TextStyle(color: Colors.white),
            )),
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          )
        ],
      ),
    );
  }
}
