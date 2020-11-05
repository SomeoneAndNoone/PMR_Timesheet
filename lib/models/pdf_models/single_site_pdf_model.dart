import 'package:flutter/material.dart';

class SingleSitePdfModel {
  SingleSitePdfModel({
    @required this.totalHours,
    @required this.weekEnding,
    @required this.permStaffName,
    @required this.pmrStaffName,
    @required this.position,
    @required this.workedShifts,
    @required this.siteName,
    @required this.pngBytesInString,
  });

  final List<SingleShiftForSingleSitePdf> workedShifts;
  final String pmrStaffName;
  final String totalHours;
  final String weekEnding;
  final String position;
  final String permStaffName;
  final String siteName;
  final String pngBytesInString;
}

class SingleShiftForSingleSitePdf {
  SingleShiftForSingleSitePdf({
    @required this.shiftDate,
    @required this.stTime,
    @required this.endTime,
    @required this.breakTime,
    @required this.shiftWeekDay,
    @required this.comments,
    @required this.totalWorkedHrs,
  });

  String shiftDate;
  String shiftWeekDay;
  String breakTime;
  String stTime;
  String endTime;
  String totalWorkedHrs;
  String comments;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return shiftDate;
      case 1:
        return shiftWeekDay;
      case 2:
        return stTime;
      case 3:
        return breakTime;
      case 4:
        return endTime;
      case 5:
        return totalWorkedHrs;
      case 6:
        return comments;
    }
    return shiftWeekDay;
  }

  static List<SingleShiftForSingleSitePdf> generateShiftsForAllWeek() {
    List<SingleShiftForSingleSitePdf> list = [];
    list.add(_generateEmptyObject('Mon'));
    list.add(_generateEmptyObject('Tue'));
    list.add(_generateEmptyObject('Wed'));
    list.add(_generateEmptyObject('Thu'));
    list.add(_generateEmptyObject('Fri'));
    list.add(_generateEmptyObject('Sat'));
    list.add(_generateEmptyObject('Sun'));
    return list;
  }

  static SingleShiftForSingleSitePdf _generateEmptyObject(String weekDay) {
    return SingleShiftForSingleSitePdf(
      shiftDate: '',
      stTime: '',
      endTime: '',
      breakTime: '',
      shiftWeekDay: weekDay,
      comments: '',
      totalWorkedHrs: '',
    );
  }
}
