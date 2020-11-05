import 'package:flutter/material.dart';
import 'package:pmr_staff/components/site_details_card.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/controller/database_helper.dart';

class HistoryShiftsScreen extends StatefulWidget {
  HistoryShiftsScreen({@required this.historyShiftGroup});

  final ShiftGroupModel historyShiftGroup;

  @override
  _HistoryShiftsScreenState createState() => _HistoryShiftsScreenState();
}

class _HistoryShiftsScreenState extends State<HistoryShiftsScreen> {
  String title = 'Site Name';
  ShiftGroupModel shiftGroupModel;
  List<SingleShiftModel> shifts = [];

  @override
  void initState() {
    super.initState();
    shiftGroupModel = widget.historyShiftGroup;
    title = shiftGroupModel.name;
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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
                      shouldIncludeDelete: false,
                      position: shiftGroupModel.jobPosition,
                      weekEnding:
                          getDDMMfromMillisecs(shiftGroupModel.weekEnding),
                      curShift: shifts[index],
                    );
                  },
                  itemCount: shifts.length,
                ),
              ),
            ],
          )),
    );
  }

  void updateData() {
    DbInstance.dbHelper
        .getShiftModelsForParticularGroup(shiftGroupModel.uniqueGroupId)
        .then((mShifts) {
      shifts = mShifts;
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
