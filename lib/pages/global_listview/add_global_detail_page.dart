import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/common_widget/common_textFormFiled.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/global_listview/globalModel.dart';
import 'package:sheet_demo/pages/global_listview/show_global_details.dart';

int listIndex;
List<Student> studentList = [];

class AddGlobalDetailsPage extends StatefulWidget {
  final bool isUpdate;

  AddGlobalDetailsPage({this.isUpdate = false});

  @override
  _AddGlobalDetailsPageState createState() => _AddGlobalDetailsPageState();
}
TextEditingController rollNoController = TextEditingController();
TextEditingController nameController = TextEditingController();

class _AddGlobalDetailsPageState extends State<AddGlobalDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        text: widget.isUpdate
            ? "Update Student Information"
            : "Add Student Information",
      ),
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: ColorResource.themeColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                commonTextFormFiled(
                  controller: rollNoController,
                  labelText: 'Enter Roll No',
                  type: TextInputType.number,
                  function: (){},
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Roll No field is mandatory";
                    }
                    return null;
                  },
                ),
                commonTextFormFiled(
                  controller: nameController,
                  labelText: 'Enter Name',
                  type: TextInputType.name,
                  function: (){},
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Name No field is mandatory";
                    }
                    return null;
                  },
                ),
                commonHeightBox(heightBox: 10),
                widget.isUpdate
                    ? commonMaterialButton(
                        text: 'Update',
                        function: () {
                          print(studentList[listIndex].name);
                          print(listIndex);
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              studentList[listIndex] = Student(
                                rollNo: rollNoController.text,
                                name: nameController.text,
                              );
                            });
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowGlobalDetails()));
                            rollNoController.clear();
                            nameController.clear();
                          }
                        },
                      )
                    : commonMaterialButton(
                        text: 'Register',
                        function: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            studentList.add(Student(
                              rollNo: rollNoController.text,
                              name: nameController.text,
                            ));
                            _formKey.currentState.reset();
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowGlobalDetails()));
                            rollNoController.clear();
                            nameController.clear();
                          }
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
