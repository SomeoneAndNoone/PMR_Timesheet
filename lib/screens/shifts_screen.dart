import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmr_staff/components/site_details_card.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/screens/add_new_shift_screen.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/utility/ui_functions.dart';

class SingleShiftsScreen extends StatefulWidget {
  SingleShiftsScreen({
    this.shiftGroupModel,
  });
  final ShiftGroupModel shiftGroupModel;

  @override
  _SingleShiftsScreenState createState() => _SingleShiftsScreenState();
}

class _SingleShiftsScreenState extends State<SingleShiftsScreen> {
  String title = 'Site Name';
  String jobPosition = 'Job Position';
  GlobalKey<ScaffoldState> key = GlobalKey();
  ShiftGroupModel shiftGroupModel;
  List<SingleShiftModel> shifts = [];
  List<int> workedWeekDays = [];
  BuildContext mContext;

  @override
  void initState() {
    super.initState();
    shiftGroupModel = widget.shiftGroupModel;
    title = shiftGroupModel.name;
    jobPosition = shiftGroupModel.jobPosition;
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return Material(
      child: Scaffold(
        key: key,
        appBar: AppBar(
          backgroundColor: color_accent,
          title: Text('$title Shifts'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(),
                itemBuilder: (context, index) {
                  return SiteDetailsCard(
                    shouldIncludeDelete: true,
                    position: jobPosition,
                    weekEnding:
                        getDDMMfromMillisecs(shiftGroupModel.weekEnding),
                    curShift: shifts[index],
                    deleteShiftFunc: deleteShift,
                  );
                },
                itemCount: shifts.length,
              ),
            ),
            MaterialButton(
              child: Text(
                'Add Shift for ${shiftGroupModel.name}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final bool shouldUpdate = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewShiftScreen(
                      shiftGroup: shiftGroupModel,
                      anyWorkedDate: DateTime.fromMillisecondsSinceEpoch(
                        shifts[0].date,
                      ),
                      workedWeekDays: workedWeekDays,
                    ),
                  ),
                );

                if (shouldUpdate) {
                  updateData();
                }
              },
              color: color_primary,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
            )
          ],
        ),
      ),
    );
  }

  void updateData() {
    DbInstance.dbHelper
        .getShiftModelsForParticularGroup(shiftGroupModel.uniqueGroupId)
        .then((mShifts) {
      workedWeekDays = [];
      shifts = mShifts;
      shifts.forEach((shift) {
        workedWeekDays
            .add(DateTime.fromMillisecondsSinceEpoch(shift.date).weekday);
      });
      setState(() {});
    });
  }

  void deleteShift(SingleShiftModel shiftModel) async {
    showAlertDialog(
        mContext,
        'Delete Shift',
        'Are you sure to delete this shift? You won\'t be able to return it.',
        'Yes',
        'No', () async {
      Navigator.pop(mContext);
      await DbInstance.dbHelper.deleteShiftModel(shiftModel);
      key.currentState
          .showSnackBar(SnackBar(content: Text('Shift deleted successfully!')));
      shifts.remove(shiftModel);
      setState(() {});
    });
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
