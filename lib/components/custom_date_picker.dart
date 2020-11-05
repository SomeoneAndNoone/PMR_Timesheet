import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    @required this.mainText,
    @required this.hint,
    this.errorMessage,
  });

  final String mainText;
  final String hint;
  final String errorMessage;
  final format = DateFormat("EEEE, dd MMMM, yyyy");

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23,
            ),
            child: Text(
              mainText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DateTimeField(
              format: format,
              onChanged: (date) {
                if (date == null) {
                  Provider.of<EmployeeScreenData>(context, listen: false)
                      .setShiftDate(null);
                } else {
                  Provider.of<EmployeeScreenData>(context, listen: false)
                      .setShiftDate(date.millisecondsSinceEpoch);
                }
                Provider.of<EmployeeScreenData>(context, listen: false)
                    .setShiftDate(date.millisecondsSinceEpoch);
              },
              style: TextStyle(fontSize: 17),
              cursorColor: color_primary,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade400),
                helperStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: hint,
                focusColor: color_primary,
                errorText: errorMessage,
              ),
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
