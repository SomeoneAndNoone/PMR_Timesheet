import 'dart:core';

import 'package:flutter/cupertino.dart';

class ShiftGroupModel {
  const ShiftGroupModel({
    @required this.uniqueGroupId,
    @required this.nightShiftCount,
    @required this.dayShiftCount,
    @required this.weekEnding,
    @required this.estimatedIncome,
    @required this.jobPosition,
    @required this.id,
    @required this.name,
    @required this.permStaffName,
    @required this.pngSignatureBytesInStr,
  });

  final int id;
  final String pngSignatureBytesInStr;
  final String permStaffName;
  final String jobPosition;
  final String uniqueGroupId;
  final String name;
  final int nightShiftCount;
  final int dayShiftCount;
  final int weekEnding;
  final double estimatedIncome;

  static ShiftGroupModel toShiftGroupModelObject(Map<String, dynamic> map) {
    return ShiftGroupModel(
      id: map['id'],
      name: map['name'],
      pngSignatureBytesInStr: map['pngSignatureBytesInStr'],
      permStaffName: map['permStaffName'],
      nightShiftCount: map['nightShiftCount'],
      dayShiftCount: map['dayShiftCount'],
      weekEnding: map['weekEnding'],
      jobPosition: map['jobPosition'],
      estimatedIncome: map['estimatedIncome'],
      uniqueGroupId: map['uniqueGroupId'],
    );
  }

  // pngSignatureBytes: convertStrToPoints(map['pngSignatureBytes'])
  // 'pngSignatureBytes': convertPointsToString(pngSignatureBytes),
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nightShiftCount': nightShiftCount,
      'dayShiftCount': dayShiftCount,
      'weekEnding': weekEnding,
      'pngSignatureBytesInStr': pngSignatureBytesInStr,
      'estimatedIncome': estimatedIncome,
      'uniqueGroupId': uniqueGroupId,
      'jobPosition': jobPosition,
      'permStaffName': permStaffName,
    };
  }
}
