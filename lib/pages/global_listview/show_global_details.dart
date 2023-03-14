import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/global_listview/add_global_detail_page.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ShowGlobalDetails extends StatefulWidget {
  @override
  ShowGlobalDetailsState createState() => ShowGlobalDetailsState();
}

class ShowGlobalDetailsState extends State<ShowGlobalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: "Student Information"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: ColorResource.themeColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText(
                                  text:
                                      "roll No:- ${studentList[index].rollNo}",
                                  color: ColorResource.white),
                              commonText(
                                  text: "Name:- ${studentList[index].name}",
                                  color: ColorResource.white),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: ColorResource.themeColor,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: commonText(
                                    text: "Are you sure !!",
                                    color: ColorResource.themeColor),
                                content: commonText(
                                    text:
                                        "You want to delete this record which name is ${studentList[index].name} ????"),
                                actions: [
                                  MaterialButton(
                                      child: commonText(
                                          text: 'Yes',
                                          color: ColorResource.themeColor),
                                      onPressed: () {
                                        setState(() {
                                          studentList.removeAt(index);
                                          Navigator.pop(context);
                                        });
                                      }),
                                  MaterialButton(
                                      child: commonText(
                                          text: 'No',
                                          color: ColorResource.themeColor),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                              ),
                            );
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: ColorResource.themeColor,
                          ),
                          onPressed: () {
                            nameController.text = "${studentList[index].name}";
                            rollNoController.text =
                                "${studentList[index].rollNo}";
                            setState(() {
                              listIndex = index;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddGlobalDetailsPage(
                                          isUpdate: true,
                                        )));
                          }),
                    ],
                  ),
                );
              },
              itemCount: studentList.length ?? "",
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.03),
        child: FloatingActionButton(
          backgroundColor: ColorResource.themeColor,
          child: Icon(Icons.add),
          onPressed: () {
            rollNoController.clear();
            nameController.clear();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddGlobalDetailsPage()));
          },
        ),
      ),
    );
  }
}
