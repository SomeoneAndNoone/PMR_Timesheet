import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_checker.dart';
import 'package:pmr_staff/components/custom_edit_text.dart';
import 'package:pmr_staff/components/info_alert_dialog.dart';
import 'package:pmr_staff/components/steps_widget.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:pmr_staff/models/employer_signin/employer_data.dart';
import 'package:pmr_staff/utility/check_employer_input.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/utility/point_converter.dart';
import 'package:pmr_staff/utility/random_id_generator.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class EmployerSignInScreen extends StatefulWidget {
  EmployerSignInScreen({this.employeeData});

  final EmployeeScreenData employeeData;

  @override
  _EmployerSignInScreenState createState() => _EmployerSignInScreenState();
}

const confirmTxt = 'Confirm';
const cancelTxt = 'Cancel';
const clearTxt = 'Clear';

class _EmployerSignInScreenState extends State<EmployerSignInScreen> {
  bool isSignaturePadEnabled = true;
  String leftBtnTxt = confirmTxt;
  String rightBtnTxt = clearTxt;

  String errorMsg = '';
  EmployeeScreenData employeeData;
  String name = 'Full Name';
  String siteName;
  String shiftDate;
  String shiftTime;
  String breakTime;
  String jobPosition;
  String permStaffName;
  final accentStyle = TextStyle(color: color_accent);

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    initializeVars();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployerInputData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color_accent,
          title: Text('Permanent Staff Confirmation'),
        ),
        body: Consumer<EmployerInputData>(
          builder: (context, employerData, child) {
            print('Widget rebuilt');
            print("emp name = ${employerData.getFullName()}");
            return Material(
              child: ListView(
                padding: EdgeInsets.only(bottom: 10),
                children: [
                  StepsComponent(
                    currentStep: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: RichText(
                      // textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'PMR temporary staff,  ',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Piazolla',
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: name,
                            style: accentStyle,
                          ),
                          TextSpan(text: ', worked at '),
                          TextSpan(text: '$siteName ', style: accentStyle),
                          TextSpan(text: 'as a '),
                          TextSpan(text: '$jobPosition ', style: accentStyle),
                          TextSpan(text: 'on '),
                          TextSpan(text: shiftDate, style: accentStyle),
                          TextSpan(text: ' between '),
                          TextSpan(text: shiftTime, style: accentStyle),
                          TextSpan(text: ' with a  '),
                          TextSpan(text: breakTime, style: accentStyle),
                          TextSpan(text: ' hour', style: accentStyle),
                          TextSpan(text: ' break'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // permanent staff confirmation
                  CustomChecker(
                    checkboxText: 'I confirm as a permanent staff',
                    onCheckChanged: (newValue) {
                      employerData.setDescriptionConfrimed(newValue);
                    },
                  ),
                  SizedBox(height: 15),
                  // Perm Staff Name
                  CustomEditText(
                    mainText: 'Permanent Staff Name',
                    hint: 'e.g. John Smith',
                    maxLength: 50,
                    currentText: permStaffName,
                    onTextChanged: (newValue) {
                      permStaffName = newValue;
                    },
                  ),
                  SizedBox(height: 15),
                  // Signature Pad
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Please sign here',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            color: color_accent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: AbsorbPointer(
                                absorbing: !isSignaturePadEnabled,
                                child: Signature(
                                  controller: _controller,
                                  height: 200,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: rightBtnTxt == cancelTxt
                                  ? null
                                  : () {
                                      if (_controller.isEmpty) {
                                        showSnackbar(
                                            context, 'Please, sign first!');
                                      } else {
                                        isSignaturePadEnabled = false;
                                        rightBtnTxt = cancelTxt;
                                        employerData
                                            .setIsSignatureConfirmed(true);
                                      }
                                      setState(() {});
                                    },
                              disabledColor: Colors.grey,
                              color: color_accent,
                              child: Text(
                                leftBtnTxt,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            MaterialButton(
                              onPressed: rightBtnTxt == cancelTxt
                                  ? () {
                                      employerData
                                          .setIsSignatureConfirmed(false);
                                      rightBtnTxt = clearTxt;
                                      _controller.clear();
                                      isSignaturePadEnabled = true;
                                      setState(() {});
                                    }
                                  : () {
                                      _controller.clear();
                                    },
                              color: color_accent,
                              child: Text(
                                rightBtnTxt,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Error Message
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 20),
                    child: Text(errorMsg, style: TextStyle(color: Colors.red)),
                  ),
                  // Back and Done Buttons
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  'BACK',
                                  style: TextStyle(
                                    color: color_primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            child: MaterialButton(
                              disabledColor: Colors.grey,
                              color: color_primary,
                              onPressed: () async {
                                print('${_controller.points.length}');

                                employerData.setFullName(permStaffName);
                                String error = checkEmployerInput(employerData);
                                if (error.isNotEmpty) {
                                  errorMsg = error;
                                } else if (_controller.points.length > 1000) {
                                  errorMsg =
                                      "Sorry, your signature is too long!";
                                } else if (error.isEmpty) {
                                  errorMsg = '';
                                  double workedTimeInHrs =
                                      getHoursBetweenTwoTimes(
                                          employeeData.getStartTime(),
                                          employeeData.getEndTime());
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
                                        'Shift Registration',
                                        'You confirmation will be sent to PMR with the signature. Do you want to continue?',
                                        'Yes',
                                        'No', () async {
                                      print('done clicked');
                                      await insertCurrentSavedData();
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                      Navigator.pop(context, true);
                                    });
                                  }
                                }

                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
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

  void initializeVars() {
    employeeData = widget.employeeData;
    siteName = employeeData.getSiteName();
    shiftDate = getEEEEDDMMMMYYYYFromMillisecs(employeeData.getShiftDate());
    shiftTime =
        '${getHHMM12FromMillisecs(employeeData.getStartTime())}-${getHHMM12FromMillisecs(employeeData.getEndTime())}';
    getFullNameSharedPrefs().then((fullName) {
      name = fullName;
      setState(() {});
    });
    breakTime = convertMinToHour(int.parse(employeeData.getBreakTime()));
    jobPosition = employeeData.getJobPosition();
  }

  Future<void> insertCurrentSavedData() async {
    String uniqueId = generateUniqueId();
    double workedHours = getWorkedHours(
      startTime: employeeData.getStartTime(),
      endTime: employeeData.getEndTime(),
      breakTimeInHrs: breakTime,
    );

    double estimatedIncome = getEstimatedIncome(
      workedTimeInHrs: workedHours,
      payRate: double.parse(employeeData.getHourlyRate()),
    );

    await DbInstance.dbHelper.insertScheduledShiftGroup(
      ShiftGroupModel(
        id: null,
        name: siteName,
        uniqueGroupId: uniqueId,
        pngSignatureBytesInStr: convertPointsToString(_controller.points),
        nightShiftCount: employeeData.getIsDay() == ISDAY_NIGHT ? 1 : 0,
        dayShiftCount: employeeData.getIsDay() == ISDAY_DAY ? 1 : 0,
        weekEnding: getRecentSunday(DateTime.fromMillisecondsSinceEpoch(
                employeeData.getShiftDate()))
            .millisecondsSinceEpoch,
        estimatedIncome: estimatedIncome,
        jobPosition: employeeData.getJobPosition(),
        permStaffName: permStaffName,
      ),
    );

    await DbInstance.dbHelper.insertShiftModel(
      SingleShiftModel(
        id: null,
        parentId: uniqueId,
        siteName: siteName,
        startTime: employeeData.getStartTime(),
        endTime: employeeData.getEndTime(),
        isDay: employeeData.getIsDay(),
        isSigned: ISSIGNED_SIGNED,
        workedHours: workedHours,
        comment: employeeData.getComment(),
        hourlyRate: double.parse(employeeData.getHourlyRate()),
        breakTimeInMins: int.parse(employeeData.getBreakTime()),
        date: employeeData.getShiftDate(),
        estimatedIncome: estimatedIncome,
      ),
    );

    await DbInstance.dbHelper.insertSiteNameSuggestion(siteName);
  }

  double getWorkedHours({
    int startTime,
    int endTime,
    String breakTimeInHrs,
  }) {
    return getHoursBetweenTwoTimes(startTime, endTime) -
        double.parse(breakTimeInHrs);
  }

  double getEstimatedIncome({
    double workedTimeInHrs,
    double payRate,
  }) {
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
