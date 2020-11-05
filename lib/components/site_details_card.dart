import 'package:flutter/material.dart';
import 'package:pmr_staff/components/click_animation_widget.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/utility/data_utils.dart';

class SiteDetailsCard extends StatelessWidget {
  const SiteDetailsCard({
    @required this.shouldIncludeDelete,
    this.weekEnding,
    @required this.curShift,
    this.deleteShiftFunc,
    @required this.position,
  });

  final Function deleteShiftFunc;
  final String position;
  final SingleShiftModel curShift;
  final bool shouldIncludeDelete;
  final String weekEnding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
      child: Material(
        elevation: 1,
        color: curShift.isSigned == ISSIGNED_SIGNED
            ? Colors.green.shade100
            : Colors.white,
        child: InkWellOverlay(
          openContainerCallback: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SHIFT DAY and DELETE icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${getWeekDayFromMillisecs(curShift.date)} - ${curShift.isDay == ISDAY_DAY ? 'Day' : 'Night'}',
                        style: TextStyle(
                          color: color_primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: shouldIncludeDelete &&
                            curShift.isSigned == ISSIGNED_NOT_SIGNED,
                        child: GestureDetector(
                          onTap: () {
                            // showSnackbar(context, 'Tapped');
                            deleteShiftFunc(curShift);
                          },
                          child: Icon(
                            Icons.delete,
                            color: color_primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  // DATE
                  Text(
                    getDDMMMMYYYYFromMillisecs(curShift.date),
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 3),
                  // W/E
                  Row(
                    children: [
                      Text(
                        'W/E: ',
                        style: TextStyle(),
                      ),
                      Text(
                        weekEnding,
                        style: TextStyle(
                            color: color_accent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // SITE NAME
                  Container(
                    width: double.infinity,
                    child: Text(
                      curShift.siteName,
                      style: TextStyle(
                          color: color_accent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      // time rate
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // add here
                          Row(
                            children: [
                              Text(
                                'Position: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                position,
                                style: TextStyle(color: color_accent),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Time
                          Row(
                            children: [
                              Text(
                                'Time: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${getHHMM12FromMillisecs(curShift.startTime)} - ${getHHMM12FromMillisecs(curShift.endTime)}'
                                    .toLowerCase(),
                                style: TextStyle(color: color_accent),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Rate
                          Row(
                            children: [
                              Text(
                                'Rate: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '£${getFormattedDouble(curShift.hourlyRate)}',
                                style: TextStyle(color: color_accent),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // break earning
                      SizedBox(width: 20),
                      // COLUMN 2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'WorkedHours: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${getFormattedDouble(curShift.workedHours)}',
                                style: TextStyle(color: color_accent),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Break
                          Row(
                            children: [
                              Text(
                                'Break: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${convertMinToHour(curShift.breakTimeInMins)} hour',
                                style: TextStyle(color: color_accent),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Earning
                          Row(
                            children: [
                              Text(
                                'Earning: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '£${getFormattedDouble(curShift.estimatedIncome)}',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Shift Time
                  SizedBox(height: 5),
                  // Comment
                  Row(
                    children: [
                      Text(
                        'Comment: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        curShift.comment == 'No Comment!'
                            ? "N/A"
                            : curShift.comment,
                        style: TextStyle(color: color_accent),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
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
///
///
///
///
