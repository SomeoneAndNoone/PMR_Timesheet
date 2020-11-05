import 'package:pmr_staff/models/employee_screen/employee_data.dart';

String checkEmployeeInput(EmployeeScreenData data) {
  String error = '';
  if (data.getSiteName() == null || data.getSiteName().trim().isEmpty) {
    error += 'Site Name cannot be empty';
  }

  if (data.getShiftDate() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Shift Date cannot be empty';
  }

  if (data.getIsDay() == null || data.getIsDay() > 1 || data.getIsDay() < 0) {
    if (error != '') {
      error += ', ';
    }
    error += 'Shift Time cannot be empty';
  }

  if (data.getStartTime() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Start Time cannot be empty';
  }

  if (data.getEndTime() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'End Time cannot be empty';
  }

  if (data.getBreakTime() == null || data.getBreakTime().trim().isEmpty) {
    if (error != '') {
      error += ', ';
    }
    error += 'Break Time cannot be empty';
  } else if (int.tryParse(data.getBreakTime()) == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Break Time Invalid Format';
  }

  if (data.getHourlyRate() == null || data.getHourlyRate().trim().isEmpty) {
    if (error != '') {
      error += ', ';
    }
    error += 'Hourly Rate cannot be empty';
  } else if (double.tryParse(data.getHourlyRate()) == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Hourly Rate Invalid Format';
  }

  if (data.getComment() == null || data.getComment().isEmpty) {
    data.setComment('No Comment!');
  }

  return error;
}

String checkNewShiftDateInput(
    EmployeeScreenData data, DateTime anyWorkedDate, List<int> workedWeekDays) {
  String error = '';
  if (data.getSiteName() == null || data.getSiteName().trim().isEmpty) {
    error += 'Site Name cannot be empty';
  }

  if (data.getShiftDate() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Shift Date cannot be empty';
  } else if (workedWeekDays.contains(
      DateTime.fromMillisecondsSinceEpoch(data.getShiftDate()).weekday)) {
    if (error != '') {
      error += ', ';
    }

    error += 'You already worked in this day';
  }

  if (data.getIsDay() == null || data.getIsDay() > 1 || data.getIsDay() < 0) {
    if (error != '') {
      error += ', ';
    }
    error += 'Shift Time cannot be empty';
  }

  if (data.getStartTime() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Start Time cannot be empty';
  }

  if (data.getEndTime() == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'End Time cannot be empty';
  }

  if (data.getShiftDate() != null) {
    String tError = checkWorkedDate(
      DateTime.fromMillisecondsSinceEpoch(data.getShiftDate()),
      anyWorkedDate,
    );
    if (tError != '') {
      if (error != '') {
        error += ', ';
      }
      error += tError;
    }
  }

  if (data.getBreakTime() == null || data.getBreakTime().trim().isEmpty) {
    if (error != '') {
      error += ', ';
    }
    error += 'Break Time cannot be empty';
  } else if (int.tryParse(data.getBreakTime()) == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Break Time Invalid Format';
  }

  if (data.getHourlyRate() == null || data.getHourlyRate().trim().isEmpty) {
    if (error != '') {
      error += ', ';
    }
    error += 'Hourly Rate cannot be empty';
  } else if (double.tryParse(data.getHourlyRate()) == null) {
    if (error != '') {
      error += ', ';
    }
    error += 'Hourly Rate Invalid Format';
  }

  if (data.getComment() == null || data.getComment().isEmpty) {
    data.setComment('No Comment!');
  }

  return error;
}

String checkWorkedDate(DateTime newWorkedDate, DateTime anyWorkedDate) {
  // worked Dates have at least a date
  DateTime prevSunday = getPreviousSundayForDate(anyWorkedDate);
  DateTime comingMonday = getComingMondayForDate(anyWorkedDate);
  DateTime mNewWorkDate = newWorkedDate.add(Duration(hours: 12));

  print('new work date = ${mNewWorkDate.day}');
  print('coming monday date = ${comingMonday.day}');
  print('new work hour = ${mNewWorkDate.hour}');
  print('coming monday hour = ${comingMonday.hour}');
  print(
      'is new workdate after coming Monday? = ${mNewWorkDate.isAfter(comingMonday)}');

  if (mNewWorkDate.isAfter(comingMonday) || mNewWorkDate.isBefore(prevSunday)) {
    return 'Shift date is not for this week ending';
  }
  return '';
}

DateTime getComingMondayForDate(DateTime date) {
  DateTime comingMonday = date;
  if (date.weekday == 1) {
    comingMonday = date.add(Duration(days: 1));
  }

  while (comingMonday.weekday != 1) {
    comingMonday = comingMonday.add(Duration(days: 1));
  }

  comingMonday = comingMonday.subtract(Duration(hours: comingMonday.hour));

  return comingMonday;
}

DateTime getPreviousSundayForDate(DateTime date) {
  DateTime prevSunday = date;
  if (date.weekday == 7) {
    prevSunday = date.subtract(Duration(days: 1));
  }

  while (prevSunday.weekday != 7) {
    prevSunday = prevSunday.subtract(Duration(days: 1));
  }

  prevSunday = prevSunday.add(Duration(hours: 23 - prevSunday.hour));

  return prevSunday;
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
