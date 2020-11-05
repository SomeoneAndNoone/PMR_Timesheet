import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/screens/history_item.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/utility/ui_functions.dart';

import '../single_scheduled_task.dart';
import 'history_shifts_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  List<ShiftGroupModel> historyShifts = [];

  @override
  void initState() {
    super.initState();
    updateHistoryShifts();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
      loadingText: 'Please wait...',
      backgroundColor: color_primary,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color_accent,
          actions: <Widget>[
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  showAlertDialog(
                      context,
                      'Warning!',
                      'Are you sure to clear history? You will loose all data!',
                      'Yes',
                      'No', () async {
                    Navigator.pop(context);
                    showProgressDialog();
                    DbInstance.dbHelper.deleteHistoryShifts().then((value) {
                      showSnackbar(context, 'Progress finished successfully!');
                      dismissProgressDialog();
                      updateHistoryShifts();
                    });
                  });
                },
                child: Icon(Icons.delete),
              ),
            ),
          ],
          title: Text('History'),
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 60),
          itemBuilder: (context, index) {
            return OpenContainerWrapper(
              returningScreen: () =>
                  HistoryShiftsScreen(historyShiftGroup: historyShifts[index]),
              transitionType: _transitionType,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return SingleHistoryItem(
                  openContainerCallback: openContainer,
                  shiftGroup: historyShifts[index],
                  deleteHistory: (ShiftGroupModel shiftGroup) {
                    showAlertDialog(
                        context,
                        'Warning!!!',
                        'Are you sure to delete? You will not be able to get your data back!',
                        'OK',
                        'CANCEL', () {
                      Navigator.pop(context);
                      DbInstance.dbHelper
                          .deleteHistoryShiftGroup(shiftGroup)
                          .then((value) {
                        showSnackbar(context, 'Deleted Successfully');
                        updateHistoryShifts();
                      });
                    });
                  },
                  moveBackHistory: (ShiftGroupModel shiftGroup) {
                    print('moving back to scheduled');
                    DbInstance.dbHelper
                        .moveShiftGroupToScheduledFromHistory(shiftGroup)
                        .then((value) {
                      print('finished updating');
                      updateHistoryShifts();
                    });
                  },
                );
              },
              // onClosed: _showMarkedAsDoneSnackbar,
            );
          },
          //
          itemCount: historyShifts.length,
        ),
      ),
    );
  }

  void updateHistoryShifts() {
    print('getting hisotry items');
    DbInstance.dbHelper.getHistoryShiftModels().then((value) {
      historyShifts = value;
      print('history items size');
      setState(() {});
    });
  }
}
