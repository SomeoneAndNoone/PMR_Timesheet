import 'package:flutter/foundation.dart';

class EmployeeScreenData extends ChangeNotifier {
  String _siteName;
  int _shiftDate;
  int _isDay;
  int _startTime;
  int _endTime;
  String _breakTime;
  String _hourlyRate;
  String _comment = 'No Comment!';
  String _jopPosition;

  void setSiteName(String value) {
    _siteName = value;
  }

  void setJobPosition(String value) {
    _jopPosition = value;
  }

  String getJobPosition() {
    return _jopPosition;
  }

  String getSiteName() => _siteName;

  void setShiftDate(int millisecondsSinceEpoch) {
    _shiftDate = millisecondsSinceEpoch;
  }

  void setShiftDateWithObj(DateTime date) {
    _shiftDate = date.millisecondsSinceEpoch;
  }

  int getShiftDate() => _shiftDate;

  void setIsDay(int value) {
    _isDay = value;
  }

  int getIsDay() => _isDay;

  void setStartTime(int millisecsFromEpoch) {
    _startTime = millisecsFromEpoch;
  }

  int getStartTime() => _startTime;

  void setEndTime(int millisecsFromEpoch) {
    _endTime = millisecsFromEpoch;
  }

  int getEndTime() => _endTime;

  void setBreakTime(String value) {
    _breakTime = value;
  }

  String getBreakTime() => _breakTime;

  void setHourlyRate(String value) {
    _hourlyRate = value;
  }

  String getHourlyRate() => _hourlyRate;

  void setComment(String value) {
    _comment = value;
  }

  String getComment() => _comment;
}
