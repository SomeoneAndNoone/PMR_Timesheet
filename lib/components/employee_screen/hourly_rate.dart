import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_number_text_filed.dart';
import 'package:pmr_staff/components/custom_time_picker.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:provider/provider.dart';

class HourlyRateWidget extends StatelessWidget {
  const HourlyRateWidget({this.currentText, this.onTextChanged});

  final String currentText;
  final Function onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomNumberTextField(
        mainText: 'Hourly Rate(£): ',
        hint: '10',
        suffix: 'per hour',
        maxLength: 5,
        currentText: currentText,
        onTextChanged: (money) {
          onTextChanged(money);
        },
      ),
    );
  }
}
