import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmr_staff/components/click_animation_widget.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/utility/ui_functions.dart';

class SingleScheduledTaskWidget extends StatelessWidget {
  const SingleScheduledTaskWidget({
    this.openContainerCallback,
    this.shiftGroupModel,
    this.moveToHistoryFunc,
    this.isItemSelected,
    this.setAsSelectedOnLongPress,
    this.setItemAsSelectedOnPress,
    this.isInSelectableState,
  });

  final ShiftGroupModel shiftGroupModel;
  final VoidCallback openContainerCallback;
  final Function moveToHistoryFunc;
  final Function isItemSelected;
  final bool isInSelectableState;
  final Function setItemAsSelectedOnPress;
  final Function setAsSelectedOnLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isItemSelected(shiftGroupModel) ? selected_item_color : Colors.white,
      child: GestureDetector(
        onLongPress: () {
          setAsSelectedOnLongPress(shiftGroupModel);
        },
        child: InkWellOverlay(
          openContainerCallback: isInSelectableState
              ? () => {setItemAsSelectedOnPress(shiftGroupModel)}
              : openContainerCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          shiftGroupModel.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: fade_color_accent,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '+£${getFormattedDouble(shiftGroupModel.estimatedIncome)}',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            moveToHistoryFunc(shiftGroupModel);
                            showSnackbar(context,
                                '${shiftGroupModel.name} moved to History');
                            break;
                        }
                        print(value);
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Move to History'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Send to Payroll'),
                            value: 1,
                          ),
                        ];
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: color_primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${shiftGroupModel.dayShiftCount} day and ${shiftGroupModel.nightShiftCount} night shifts'),
                    Text(
                      getDDMMYYYYfromMillisecs(shiftGroupModel.weekEnding),
                      style: TextStyle(color: color_primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.returningScreen,
  });

  final Function returningScreen;
  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: OpenContainer<bool>(
        transitionType: transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return returningScreen();
        },
        onClosed: onClosed,
        tappable: false,
        closedBuilder: closedBuilder,
      ),
    );
  }
}
