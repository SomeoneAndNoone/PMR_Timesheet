import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pmr_staff/components/info_alert_dialog.dart';
import 'package:pmr_staff/components/main_screen/list_view.dart';
import 'package:pmr_staff/components/main_screen/press_button_hint.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/constants/screen_ids.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/screens/employee_signin_screen.dart';
import 'package:pmr_staff/screens/registration_screen.dart';
import 'package:pmr_staff/screens/send_shifts_screen.dart';
import 'package:pmr_staff/single_scheduled_task.dart';
import 'package:pmr_staff/utility/check_employee_input.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/utility/notificatins_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

const String _sendScheduledShiftsStr = 'Send Scheduled Shifts';
const String _sendSelectedShiftsStr = 'Send Selected Shifts';

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // vars to change selected state
  bool _isSelectedState = false;
  bool _isAllSelectedState = false;
  String sendBtnTxt = _sendScheduledShiftsStr;
  List<ShiftGroupModel> selectedShifts = [];

  List<ShiftGroupModel> scheduledShifts = [];
  int scheduledShiftsCount = 0;
  double estimatedIncome = 0.0;
  @override
  void initState() {
    super.initState();
    updateScheduledShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: color_accent,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final bool shouldUpdate = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeSigninScreen(),
              ),
            );

            if (shouldUpdate) updateScheduledShifts();
          },
          backgroundColor: color_accent,
          child: Icon(Icons.add),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50, left: 20, right: 30, bottom: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunch(pmrRegistrationUrl))
                              await launch(pmrRegistrationUrl);
                          },
                          child: Material(
                            elevation: 10,
                            shape: CircleBorder(),
                            child: Image.asset(
                              'assets/main_logo.png',
                              width: 40,
                              // color: color_primary,
                              height: 40,
                              // semanticsLabel: 'PMR Logo',
                            ),
                            borderOnForeground: true,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    child: InfoAlertDialog(
                                      title: 'Important Info',
                                      bodyText: '1. Please ensure that your timesheet is completed with the correct dates and times of your shift(s)\n\n' +
                                          '2. Employees are paid on a 2 weekly basis on a Friday. Timesheets should be submitted to the PMR payroll department on Monday before 13:00 hours in order for payment to credit bank accounts the following Friday.\n\n' +
                                          '3. Timesheets received after this time will not be processed within this payroll and will be held until the next available payroll.',
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                        context, history_screen_id);
                                    updateScheduledShifts();
                                  },
                                  child: Icon(
                                    Icons.history,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, account_screen_id);
                                  },
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 20, right: 30, bottom: 10),
                    child: Text(
                      'PMR Timesheet',
                      style: TextStyle(
                        color: color_primary,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                    child: Text(
                      '+£${getFormattedDouble(estimatedIncome)}',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 0, left: 20, right: 30, bottom: 5),
                    child: Text(
                      '$scheduledShiftsCount shift${scheduledShiftsCount == 1 ? '' : 's'} '
                      'scheduled\non ${getEEEEDDMMMMYYYYFromMillisecs(getComingMondayForDate(DateTime.now()).millisecondsSinceEpoch)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: MaterialButton(
                          onPressed: scheduledShifts.length == 0
                              ? null
                              : () {
                                  if (!_isSelectedState) {
                                    print("Scheduled Shifts");
                                    sendScheduledShifts();
                                  } else {
                                    print(
                                        "Selected Shifts Size = ${selectedShifts.length}");
                                    sendSelectedShifts();
                                  }
                                },
                          disabledColor: Colors.grey,
                          color: color_primary,
                          child: Text(
                            _isSelectedState
                                ? _sendSelectedShiftsStr
                                : _sendScheduledShiftsStr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => Visibility(
                          visible: _isSelectedState,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 10),
                            child: MaterialButton(
                              onPressed: () async {
                                print('donkey');
                                await moveSelectedShiftsToHistory();
                                showSnackbar(context,
                                    'Shifts have been moved to history');
                              },
                              disabledColor: Colors.grey,
                              color: color_primary,
                              child: Text(
                                'Move to History',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scheduled Shifts for Payroll',
                              style: TextStyle(
                                fontSize: 20,
                                color: color_primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value: _isAllSelectedState,
                              onChanged: (newValue) {
                                if (_isAllSelectedState) {
                                  selectedShifts.clear();
                                  _isSelectedState = false;
                                  _isAllSelectedState = false;
                                } else if (scheduledShifts.isNotEmpty) {
                                  selectedShifts.clear();
                                  selectedShifts.addAll(scheduledShifts);
                                  _isSelectedState = true;
                                  _isAllSelectedState = true;
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: scheduledShifts.length == 0
                          ? PressButtonHint()
                          : MainScreenList(
                              isInSelectableState: _isSelectedState,
                              setAsSelectedOnLongPress:
                                  setAsSelectedOnLongPress,
                              setItemAsSelectedOnPress:
                                  setItemAsSelectedOnPress,
                              isItemSelected: isItemSelected,
                              moveToHistoryFunc: moveToHistory,
                              scheduledShifts: scheduledShifts,
                              sendToPayroll: sendToPayroll,
                              onClosedCallback: onClosedFunc,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void onClosedFunc(bool shouldUpdate) {
    updateScheduledShifts();
    setState(() {});
  }

  bool isItemSelected(ShiftGroupModel shiftGroupModel) {
    return selectedShifts.contains(shiftGroupModel);
  }

  void setItemAsSelectedOnPress(ShiftGroupModel shiftGroupModel) {
    if (isItemSelected(shiftGroupModel)) {
      selectedShifts.remove(shiftGroupModel);
    } else {
      selectedShifts.add(shiftGroupModel);
    }

    if (selectedShifts.length == 0) {
      _isSelectedState = false;
    }
    setState(() {});
  }

  void setAsSelectedOnLongPress(ShiftGroupModel shiftGroupModel) {
    _isSelectedState = true;
    if (!selectedShifts.contains(shiftGroupModel)) {
      selectedShifts.add(shiftGroupModel);
    }
    setState(() {});
  }

  Future<void> moveSelectedShiftsToHistory() async {
    for (int i = 0; i < selectedShifts.length; i++) {
      await DbInstance.dbHelper
          .moveShiftGroupToHistoryFromScheduled(selectedShifts[i]);
    }

    _isAllSelectedState = false;
    _isSelectedState = false;
    selectedShifts.clear();

    updateScheduledShifts();
  }

  void moveToHistory(ShiftGroupModel shiftGroupModel) async {
    await DbInstance.dbHelper
        .moveShiftGroupToHistoryFromScheduled(shiftGroupModel);

    updateScheduledShifts();
  }

  void sendToPayroll(ShiftGroupModel shiftGroupModel) async {
    final bool shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendShiftsScreen(
          scheduledShifts: [shiftGroupModel],
        ),
      ),
    );
  }

  void updateScheduledShifts() {
    DbInstance.dbHelper.getScheduledShiftModels().then((value) {
      scheduledShifts = value;
      getScheduledShiftsCountAndIncome();
      setState(() {});
    });
  }

  void getScheduledShiftsCountAndIncome() {
    scheduledShiftsCount = 0;
    estimatedIncome = 0.0;
    scheduledShifts.forEach((element) {
      scheduledShiftsCount += element.dayShiftCount + element.nightShiftCount;
      estimatedIncome += element.estimatedIncome;
    });
  }

  void sendSelectedShifts() async {
    final bool shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendShiftsScreen(
          scheduledShifts: selectedShifts,
        ),
      ),
    );
  }

  void sendScheduledShifts() async {
    final bool shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendShiftsScreen(
          scheduledShifts: scheduledShifts,
        ),
      ),
    );
  }
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
