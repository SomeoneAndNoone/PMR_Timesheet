import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_date_picker.dart';
import 'package:pmr_staff/components/custom_edit_text.dart';
import 'package:pmr_staff/components/employee_screen/comment_widget.dart';
import 'package:pmr_staff/components/employee_screen/hourly_rate.dart';
import 'package:pmr_staff/components/employee_screen/shift_duration.dart';
import 'package:pmr_staff/components/employee_screen/unpaid_break_widget.dart';
import 'package:pmr_staff/components/info_alert_dialog.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:pmr_staff/utility/check_employee_input.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';
import 'package:provider/provider.dart';

class AddNewShiftScreen extends StatefulWidget {
  AddNewShiftScreen({
    @required this.shiftGroup,
    @required this.anyWorkedDate,
    @required this.workedWeekDays,
  });

  final List<int> workedWeekDays;
  final ShiftGroupModel shiftGroup;
  final DateTime anyWorkedDate;
  @override
  _AddNewShiftScreenState createState() => _AddNewShiftScreenState();
}

class _AddNewShiftScreenState extends State<AddNewShiftScreen> {
  final date = DateTime.now();
  bool isButtonDisabled = false;

  String pmrFullName = '';
  String errorMsg = '';
  ShiftGroupModel shiftGroup;
  List<int> workedWeekDays;
  DateTime anyWorkedDate;

  @override
  void initState() {
    super.initState();
    shiftGroup = widget.shiftGroup;
    anyWorkedDate = widget.anyWorkedDate;
    workedWeekDays = widget.workedWeekDays;

    getFullNameSharedPrefs().then((value) {
      pmrFullName = value;
      setState(() {});
    });
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
          title: Text('New Shift'),
        ),
        body: Consumer<EmployeeScreenData>(
          builder: (context, taskData, child) {
            return Material(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 10),
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(errorMsg, style: TextStyle(color: Colors.red)),
                  ),
                  SizedBox(height: 15),
                  // Full Name
                  CustomEditText(
                    mainText: 'Full Name',
                    hint: 'e.g. Ann Pego',
                    maxLength: 50,
                    isEditable: false,
                    currentText: pmrFullName,
                  ),
                  CustomEditText(
                    mainText: 'Job Position',
                    hint: 'e.g. Concierge',
                    maxLength: 50,
                    isEditable: false,
                    currentText: shiftGroup.jobPosition,
                  ),
                  // Site Name
                  CustomEditText(
                    mainText: 'Site Name',
                    maxLength: 50,
                    isEditable: false,
                    hint: '',
                    currentText: shiftGroup.name,
                  ),
                  SizedBox(height: 15),
                  // Shift Date
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
                  // Comment
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
                    padding: const EdgeInsets.only(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          disabledColor: Colors.grey,
                          color: color_primary,
                          onPressed: () async {
                            taskData.setSiteName(shiftGroup.name);
                            String error = checkNewShiftDateInput(
                                taskData, anyWorkedDate, workedWeekDays);
                            if (error.isNotEmpty) {
                              errorMsg = error;
                              _scrollToStart();
                              setState(() {});
                            } else {
                              errorMsg = '';
                              setState(() {});

                              double workedTimeInHrs = getHoursBetweenTwoTimes(
                                  taskData.getStartTime(),
                                  taskData.getEndTime());
                              if (workedTimeInHrs < 4.0) {
                                showDialog(
                                  context: context,
                                  child: InfoAlertDialog(
                                    title: 'Invalid Working Hour',
                                    bodyText:
                                        'Sorry, minimum working-hour period is 4! Please check your input!',
                                  ),
                                );
                              } else {
                                showAlertDialog(
                                    context,
                                    'New Shift',
                                    'Do you want to add this shift?',
                                    'Yes',
                                    'No', () async {
                                  await saveDataToModel(taskData);
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Text(
                              'Add Shift',
                              style: TextStyle(
                                color: Colors.white,
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

  void saveDataToModel(EmployeeScreenData employeeData) async {
    String breakTime = convertMinToHour(int.parse(employeeData.getBreakTime()));
    double estimatedIncome = getEstimatedIncome(
        startTime: employeeData.getStartTime(),
        endTime: employeeData.getEndTime(),
        breakTimeInHrs: breakTime,
        payRate: double.parse(employeeData.getHourlyRate()));

    double workedTimeInHrs = getHoursBetweenTwoTimes(
            employeeData.getStartTime(), employeeData.getEndTime()) -
        int.parse(employeeData.getBreakTime()) * 1.0 / 60;

    int dayShiftCount = shiftGroup.dayShiftCount;
    int nightShiftCount = shiftGroup.nightShiftCount;

    if (employeeData.getIsDay() == ISDAY_DAY) {
      dayShiftCount++;
    } else {
      nightShiftCount++;
    }

    shiftGroup = ShiftGroupModel(
      id: shiftGroup.id,
      uniqueGroupId: shiftGroup.uniqueGroupId,
      dayShiftCount: dayShiftCount,
      nightShiftCount: nightShiftCount,
      weekEnding: shiftGroup.weekEnding,
      estimatedIncome: shiftGroup.estimatedIncome + estimatedIncome,
      name: shiftGroup.name,
      pngSignatureBytesInStr: shiftGroup.pngSignatureBytesInStr,
      permStaffName: shiftGroup.permStaffName,
      jobPosition: shiftGroup.jobPosition,
    );

    await DbInstance.dbHelper.insertShiftModel(SingleShiftModel(
      id: null,
      parentId: shiftGroup.uniqueGroupId,
      siteName: shiftGroup.name,
      startTime: employeeData.getStartTime(),
      endTime: employeeData.getEndTime(),
      isDay: employeeData.getIsDay(),
      isSigned: ISSIGNED_NOT_SIGNED,
      comment: employeeData.getComment(),
      hourlyRate: double.parse(employeeData.getHourlyRate()),
      breakTimeInMins: int.parse(employeeData.getBreakTime()),
      date: employeeData.getShiftDate(),
      estimatedIncome: estimatedIncome,
      workedHours: workedTimeInHrs,
    ));
    await DbInstance.dbHelper.updateScheduledShiftIncome(shiftGroup);
  }

  double getEstimatedIncome({
    int startTime,
    int endTime,
    String breakTimeInHrs,
    double payRate,
  }) {
    double workedTimeInHrs = getHoursBetweenTwoTimes(startTime, endTime);
    workedTimeInHrs -= double.parse(breakTimeInHrs);
    return workedTimeInHrs * payRate;
  }
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
