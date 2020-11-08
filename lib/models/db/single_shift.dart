import 'package:flutter/cupertino.dart';

const ISDAY_DAY = 0;
const ISDAY_NIGHT = 1;
const ISSIGNED_SIGNED = 0;
const ISSIGNED_NOT_SIGNED = 1;

class SingleShiftModel {
  const SingleShiftModel({
    @required this.parentId,
    @required this.id,
    @required this.siteName,
    @required this.startTime,
    @required this.endTime,
    @required this.isDay,
    @required this.breakTimeInMins,
    @required this.isSigned,
    @required this.hourlyRate,
    @required this.date,
    @required this.comment,
    @required this.estimatedIncome,
    @required this.workedHours,
  });

  final int id;
  final double workedHours;
  final String siteName;
  final int startTime;
  final int endTime;
  final int date;
  final int isDay;
  final int breakTimeInMins;
  final int isSigned;
  final double hourlyRate;
  final String parentId;
  final double estimatedIncome;
  final String comment;

  static SingleShiftModel toShiftModelObject(Map<String, dynamic> map) {
    return SingleShiftModel(
      id: map['id'],
      siteName: map['siteName'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      date: map['date'],
      isDay: map['isDay'],
      workedHours: map['workedHours'],
      breakTimeInMins: map['breakTimeInMins'],
      isSigned: map['isSigned'],
      parentId: map['parentId'],
      estimatedIncome: map['estimatedIncome'],
      hourlyRate: map['hourlyRate'],
      comment: map['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siteName': siteName,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'isDay': isDay,
      'estimatedIncome': estimatedIncome,
      'breakTimeInMins': breakTimeInMins,
      'workedHours': workedHours,
      'isSigned': isSigned,
      'parentId': parentId,
      'hourlyRate': hourlyRate,
      'comment': comment
    };
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
