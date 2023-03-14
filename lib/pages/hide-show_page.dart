import 'package:flutter/material.dart';
import 'package:sheet_demo/generated/l10n.dart';

class HideShowPage extends StatefulWidget {
  @override
  HideShowPageState createState() => new HideShowPageState();
}

class HideShowPageState extends State<HideShowPage> {
  bool visibilityObs = false;

  TextEditingController observationController = TextEditingController();

  changed(bool visibility, String field) {
    setState(() {
      if (field == "obs") {
        visibilityObs = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).hideShowWidgetAppbar),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  visibilityObs
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 11,
                              child: TextFormField(
                                controller: observationController,
                                maxLines: 1,
                                decoration:
                                    InputDecoration(labelText: "Observation", isDense: true),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                color: Colors.grey[400],
                                icon: Icon(
                                  Icons.cancel,
                                  size: 22.0,
                                ),
                                onPressed: () {
                                  changed(false, "obs");
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  // ignore: unnecessary_statements
                  visibilityObs ? null : changed(true, "obs");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.comment,
                          color: visibilityObs ? Colors.grey[400] : Colors.grey[600]),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Observation",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: visibilityObs ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Center(child: Text(observationController.text)),
          ],
        ));
  }
}
