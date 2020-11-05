import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/employee_screen/employee_data.dart';
import 'package:provider/provider.dart';

class CustomNumberTextField extends StatelessWidget {
  CustomNumberTextField({
    @required this.mainText,
    @required this.hint,
    @required this.maxLength,
    @required this.suffix,
    @required this.onTextChanged,
    this.currentText,
  });

  final Function onTextChanged;
  final String suffix;
  final String mainText;
  final String currentText;
  final String hint;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        // height: 10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
            Container(
              width: 50,
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: onTextChanged,
                style: TextStyle(fontSize: 17),
                maxLength: maxLength,
                controller: TextEditingController()..text = currentText,
                cursorColor: color_primary,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: -5),
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  counterText: '',
                  helperStyle: TextStyle(color: Colors.grey),
                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: hint,
                  focusColor: color_primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                suffix,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          ],
        ),
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
