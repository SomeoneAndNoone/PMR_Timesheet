import 'dart:core';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

String getDDMMYYYYfromMillisecs(int milliseconds) {
  var date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return formatDate(date, [dd, '/', mm, '/', yyyy]);
}

String getDD_MM_YYYYfromMillisecs(int milliseconds) {
  var date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return formatDate(date, [ dd, '_', mm, '_', yyyy]);
}

String getDDMMfromMillisecs(int milliseconds) {
  var date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return formatDate(date, [dd, '/', mm]);
}

String getEEEEDDMMMMYYYYFromMillisecs(int millisecondsSinceEpoch) {
  var date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  return '${DateFormat.EEEE().format(date)}, ${date.day} ${DateFormat.MMMM().format(date)}, ${date.year}';
}

String getDDMMMMYYYYFromMillisecs(int millisecondsSinceEpoch) {
  var date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  return '${date.day} ${DateFormat.MMMM().format(date)}, ${date.year}';
}

String getWeekDayFromMillisecs(int millisecondsSinceEpoch) {
  var date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  return DateFormat.EEEE().format(date);
}

String getHHMM12FromMillisecs(int millisecondsSinceEpoch) {
  var date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  return formatDate(date, [hh, ':', nn, am]);
}

String convertMinToHour(int minutes) {
  String temp = (minutes.toDouble() / 60).toStringAsPrecision(2);
  if (temp.endsWith('.0')) {
    return (minutes.toDouble() / 60).toStringAsPrecision(1);
  } else {
    return temp;
  }
}

String formatDateInYMMMD(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

DateTime getRecentSunday(DateTime date) {
  int sunday = 7;
  DateTime recentSunday = date;

  while (recentSunday.weekday != sunday) {
    recentSunday = recentSunday.add(Duration(days: 1));
  }

  return recentSunday;
}

double getHoursBetweenTwoTimes(int startTime, int endTime) {
  var stDate = DateTime.fromMillisecondsSinceEpoch(startTime);
  var endDate = DateTime.fromMillisecondsSinceEpoch(endTime);

  int stMin = 0;
  int endMin = 0;

  if (stDate.minute > endDate.minute) {
    stMin = stDate.minute - endDate.minute;
  } else {
    endMin = endDate.minute - stDate.minute;
  }

  double stHr = stDate.hour.toDouble() + stMin.toDouble() / 60.0;
  double endHr = endDate.hour.toDouble() + endMin.toDouble() / 60.0;
  double dif = endHr - stHr;
  if (dif < 0) return 24.0 + dif;
  return dif;
}

String getFormattedDouble(double value) {
  var temp = value.toStringAsFixed(1);
  if (temp.endsWith('.0')) return value.toStringAsFixed(0);
  return temp;
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
