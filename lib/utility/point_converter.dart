import 'package:flutter/cupertino.dart';
import 'package:signature/signature.dart';

String convertPointsToString(List<Point> points) {
  String result = '';
  points.forEach((point) {
    String str = _convertPointToString(point);
    if (result.isEmpty) {
      result = str;
    } else {
      result += ',$str';
    }
  });

  return result;
}

// if type == tap 1, else 0
String _convertPointToString(Point point) {
  return '${point.offset.dx},${point.offset.dy},${point.type == PointType.tap ? 1 : 0}';
}

// this needs to be tested
List<Point> convertStrToPoints(String strPoints) {
  List<Point> answer = List();
  // print('strPoints=$strPoints');
  List<String> pStrs = strPoints.split(",");
  for (int i = 0; i < pStrs.length; i += 3) {
    Point point = Point(
      Offset(double.parse(pStrs[i]), double.parse(pStrs[i + 1])),
      int.parse(pStrs[i + 2]) == 1 ? PointType.tap : PointType.move,
    );
    answer.add(point);
  }
  return answer;
}
