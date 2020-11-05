import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:provider/provider.dart';

class CustomTimePicker extends StatelessWidget {
  CustomTimePicker({this.hint});

  final format = DateFormat("hh:mm a");
  final String hint;
  final DateTime sevenAMTime = DateTime(2020, 1, 1, 7, 0, 0, 0, 0);
  final DateTime sevenPMTime = DateTime(2020, 1, 1, 19, 0, 0, 0, 0);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 5),
                  child: Text(
                    'Start Time',
                    textAlign: TextAlign.start,
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 150,
                  child: DateTimeField(
                    format: format,
                    onChanged: (time) {
                      if (time == null) {
                        Provider.of<EmployeeScreenData>(context, listen: false)
                            .setStartTime(null);
                      } else {
                        Provider.of<EmployeeScreenData>(context, listen: false)
                            .setStartTime(time.millisecondsSinceEpoch);
                      }
                    },
                    style: TextStyle(fontSize: 17),
                    cursorColor: color_primary,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? sevenAMTime),
                      );
                      return DateTimeField.convert(time);
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      hintText: '07:00 AM',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              ':',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 5),
                  child: Text(
                    'End Time',
                    textAlign: TextAlign.start,
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 150,
                  child: DateTimeField(
                    format: format,
                    onChanged: (time) {
                      if (time == null) {
                        Provider.of<EmployeeScreenData>(context, listen: false)
                            .setEndTime(null);
                      } else {
                        Provider.of<EmployeeScreenData>(context, listen: false)
                            .setEndTime(time.millisecondsSinceEpoch);
                      }
                    },
                    style: TextStyle(fontSize: 17),
                    cursorColor: color_primary,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? sevenPMTime),
                      );
                      return DateTimeField.convert(time);
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      hintText: '07:00 PM',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
///
///
///
