import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_number_text_filed.dart';
import 'package:pmr_staff/components/custom_time_picker.dart';
import 'package:pmr_staff/components/employee_screen/hourly_rate.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { Day, Night }

/// This is the stateful widget that the main application instantiates.
class ShiftTimeWidget extends StatefulWidget {
  ShiftTimeWidget({Key key}) : super(key: key);

  @override
  _ShiftTimeWidget createState() => _ShiftTimeWidget();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ShiftTimeWidget extends State<ShiftTimeWidget> {
  SingingCharacter _character;

  int id = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'Shift Time',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: <Widget>[
                Radio(
                  value: SingingCharacter.Day,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) {
                    setState(() {
                      // when day is selected
                      Provider.of<EmployeeScreenData>(context, listen: false)
                          .setIsDay(ISDAY_DAY);
                      _character = value;
                    });
                  },
                ),
                Text(
                  'Day',
                  style: new TextStyle(fontSize: 17.0),
                ),
                Radio(
                  value: SingingCharacter.Night,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) {
                    setState(() {
                      Provider.of<EmployeeScreenData>(context, listen: false)
                          .setIsDay(ISDAY_NIGHT);
                      _character = value;
                    });
                  },
                ),
                Text(
                  'Night',
                  style: new TextStyle(fontSize: 17.0),
                ),
              ],
            ),
          ),
          CustomTimePicker(),
          // SizedBox(height: 15),
        ],
      ),
    );
  }
}
