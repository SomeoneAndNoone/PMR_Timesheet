import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmr_staff/components/click_animation_widget.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/screens/history_shifts_screen.dart';
import 'package:pmr_staff/utility/data_utils.dart';

class SingleHistoryItem extends StatelessWidget {
  const SingleHistoryItem({
    this.openContainerCallback,
    this.shiftGroup,
    this.deleteHistory,
    this.moveBackHistory,
  });

  final Function deleteHistory;
  final Function moveBackHistory;
  final ShiftGroupModel shiftGroup;
  final VoidCallback openContainerCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        elevation: 1,
        child: InkWellOverlay(
          openContainerCallback: openContainerCallback,
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
                          shiftGroup.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: color_primary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == 0) {
                          deleteHistory(shiftGroup);
                        } else if (value == 1) {
                          moveBackHistory(shiftGroup);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Move to Scheduled Shifts'),
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
                        '${shiftGroup.dayShiftCount} day and ${shiftGroup.nightShiftCount} night shifts'),
                    Text(
                      getDDMMYYYYfromMillisecs(shiftGroup.weekEnding),
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
