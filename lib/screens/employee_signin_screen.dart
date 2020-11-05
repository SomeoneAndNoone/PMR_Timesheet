import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_autocomplete_edit_text.dart';
import 'package:pmr_staff/components/custom_date_picker.dart';
import 'package:pmr_staff/components/custom_edit_text.dart';
import 'package:pmr_staff/components/custom_number_text_filed.dart';
import 'package:pmr_staff/components/employee_screen/comment_widget.dart';
import 'package:pmr_staff/components/employee_screen/hourly_rate.dart';
import 'package:pmr_staff/components/employee_screen/shift_duration.dart';
import 'package:pmr_staff/components/employee_screen/unpaid_break_widget.dart';
import 'package:pmr_staff/components/steps_widget.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:pmr_staff/screens/employer_signin_screen.dart';
import 'package:pmr_staff/utility/check_employee_input.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';
import 'package:provider/provider.dart';

class EmployeeSigninScreen extends StatefulWidget {
  @override
  _EmployeeSigninScreenState createState() => _EmployeeSigninScreenState();
}

class _EmployeeSigninScreenState extends State<EmployeeSigninScreen> {
  final date = DateTime.now();

  bool isButtonDisabled = false;
  List<String> siteNameSuggestions;
  String errorMsg = '';
  String pmrStaffFullName = '';
  final TextEditingController autocompleteTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getSiteNameSuggestions().then((value) {
      setState(() {});
    });
  }

  Future<void> getSiteNameSuggestions() async {
    siteNameSuggestions = await DbInstance.dbHelper.getSiteNameSuggestions();
    pmrStaffFullName = await getFullNameSharedPrefs();
  }

  final _scrollController = ScrollController();
  void _scrollToStart() {
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDate =
        getEEEEDDMMMMYYYYFromMillisecs(date.millisecondsSinceEpoch);

    return ChangeNotifierProvider(
      create: (context) => EmployeeScreenData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color_accent,
          title: Text('Shift Registration'),
        ),
        body: Consumer<EmployeeScreenData>(
          builder: (context, taskData, child) {
            return Material(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 10),
                children: [
                  StepsComponent(
                    currentStep: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(errorMsg, style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(height: 15),
                  CustomEditText(
                    mainText: 'Full Name',
                    hint: 'e.g. Ann Pego',
                    maxLength: 50,
                    isEditable: false,
                    currentText: pmrStaffFullName,
                  ),
                  CustomAutoCompleteEditText(
                    mainText: 'Site Name',
                    hint: 'e.g. Sky Gardens',
                    controller: autocompleteTextController,
                    onTextChanged: (newText) {
                      // showSnackbar(context, newText);
                      taskData.setSiteName(newText);
                    },
                    suggestions: siteNameSuggestions,
                    maxLength: 50,
                    currentText: taskData.getSiteName(),
                  ),
                  SizedBox(height: 15),
                  CustomEditText(
                    mainText: 'Job Position',
                    hint: 'e.g. Concierge',
                    maxLength: 50,
                    onTextChanged: (newText) {
                      taskData.setJobPosition(newText);
                    },
                    isEditable: true,
                  ),
                  SizedBox(height: 15),
                  CustomDatePicker(
                    mainText: 'Shift Date',
                    hint: 'e.g. $currentDate',
                  ),
                  // CustomChecker(),
                  SizedBox(height: 15),
                  ShiftTimeWidget(),
                  UnpaidBreakWidget(
                    currentText: taskData.getBreakTime(),
                    onTextChanged: (newBreak) {
                      taskData.setBreakTime(newBreak);
                    },
                  ),
                  HourlyRateWidget(
                    currentText: taskData.getHourlyRate(),
                    onTextChanged: (newRate) {
                      taskData.setHourlyRate(newRate);
                    },
                  ),
                  SizedBox(height: 35),
                  CommentWidget(
                    mainText: 'Comment',
                    hint: 'e.g Manager was excellent!',
                    currentText: taskData.getComment(),
                    maxLength: 100,
                    onCommentChanged: (newComment) {
                      taskData.setComment(newComment);
                    },
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Expanded(child: SizedBox()),
                        SizedBox(
                          child: MaterialButton(
                            disabledColor: Colors.grey,
                            color: color_primary,
                            onPressed: () async {
                              taskData
                                  .setSiteName(autocompleteTextController.text);
                              taskData
                                  .setSiteName(taskData.getSiteName().trim());
                              taskData.setJobPosition(
                                  taskData.getJobPosition().trim());
                              taskData.setComment(taskData.getComment().trim());
                              taskData
                                  .setBreakTime(taskData.getBreakTime().trim());
                              taskData.setHourlyRate(
                                  taskData.getHourlyRate().trim());

                              String error = checkEmployeeInput(taskData);
                              if (error.isNotEmpty) {
                                errorMsg = error;
                                _scrollToStart();
                                setState(() {});
                              } else {
                                errorMsg = '';
                                // bool shouldNavigateBack = await
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmployerSignInScreen(
                                        employeeData: taskData),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                'NEXT',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
