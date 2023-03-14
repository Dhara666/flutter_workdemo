import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_textFormFiled.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/model/student_model.dart';
import 'package:sheet_demo/pages/real_time_database/real_time_database.dart';
import 'package:sheet_demo/utils/validation.dart';

class AddNamePage extends StatefulWidget {
 final studentModel;
 final String tableName;
 final bool isEdit;

  AddNamePage({this.studentModel, this.tableName, this.isEdit = false});

  @override
  AddNamePageState createState() => AddNamePageState();
}

class AddNamePageState extends State<AddNamePage> {
  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  Database database = Database();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.studentModel != null) {
      print('Student data --> ${widget.studentModel}');
      nameController.text = widget.studentModel['name'];
      rollNoController.text = widget.studentModel['rollNo'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Current screen --> $runtimeType');
    return Scaffold(
      appBar: commonAppbar(
          text: widget.isEdit
              ? S.of(context).realDatabaseAddDetailsAppbar
              : S.of(context).realDatabaseAddDetailsAppbar),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: ColorResource.themeColor,
                  borderRadius: BorderRadius.circular(10)),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  commonTextFormFiled(
                      type: TextInputType.number,
                      validator: (val) => validatePrefNo(val, context),
                      controller: rollNoController,
                      labelText: 'Roll No',
                      function: () {}),
                  commonTextFormFiled(
                      type: TextInputType.text,
                      controller: nameController,
                      labelText: 'Student Name',
                      validator: (val) => validateName(val, context),
                      function: () {}),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: commonMaterialButton(
                      text: widget.isEdit ? 'Update' : 'Add',
                      function: () async {
                        if (formKey.currentState.validate()) {
                          widget.isEdit
                              ? database.updateStudentData(
                                  widget.tableName,
                                  StudentModel(
                                    name: nameController.text,
                                    rollNo: rollNoController.text,
                                    createdAt: getDate(),
                                  ),
                                )
                              : database.createStudentTable(
                                  StudentModel(
                                    name: nameController.text,
                                    rollNo: rollNoController.text,
                                    createdAt: getDate(),
                                  ),
                                );

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDate() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(DateTime.now());
  }
}
