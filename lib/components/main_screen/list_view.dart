import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/screens/shifts_screen.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import '../../single_scheduled_task.dart';

class MainScreenList extends StatelessWidget {
  MainScreenList({
    @required this.scheduledShifts,
    @required this.moveToHistoryFunc,
    @required this.isItemSelected,
    @required this.setAsSelectedOnLongPress,
    @required this.setItemAsSelectedOnPress,
    @required this.isInSelectableState,
    @required this.sendToPayroll,
    this.onClosedCallback,
  });

  final Function onClosedCallback;
  final Function sendToPayroll;
  final bool isInSelectableState;
  final Function setItemAsSelectedOnPress;
  final Function isItemSelected;
  final Function moveToHistoryFunc;
  final Function setAsSelectedOnLongPress;
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  final List<ShiftGroupModel> scheduledShifts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 60),
      itemBuilder: (context, index) {
        return OpenContainerWrapper(
          transitionType: _transitionType,
          returningScreen: () =>
              SingleShiftsScreen(shiftGroupModel: scheduledShifts[index]),
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return SingleScheduledTaskWidget(
              isInSelectableState: isInSelectableState,
              setItemAsSelectedOnPress: setItemAsSelectedOnPress,
              moveToHistoryFunc: moveToHistoryFunc,
              isItemSelected: isItemSelected,
              setAsSelectedOnLongPress: setAsSelectedOnLongPress,
              openContainerCallback: openContainer,
              shiftGroupModel: scheduledShifts[index],
              sendToPayrollFunc: sendToPayroll,
            );
          },
          onClosed: onClosedCallback,
        );
      },
      itemCount: scheduledShifts.length,
    );
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
