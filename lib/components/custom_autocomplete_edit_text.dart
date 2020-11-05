import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:pmr_staff/constants/colors.dart';

class CustomAutoCompleteEditText extends StatelessWidget {
  CustomAutoCompleteEditText({
    @required this.mainText,
    @required this.hint,
    @required this.maxLength,
    @required this.suggestions,
    @required this.onTextChanged,
    this.isEditable = true,
    this.helperText,
    this.secondaryMainText,
    this.errorMessage,
    this.currentText,
    @required this.controller,
  });

  final TextEditingController controller;
  final Function onTextChanged;
  final List<String> suggestions;
  final bool isEditable;
  final String secondaryMainText;
  final String mainText;
  final String currentText;
  final String hint;
  final int maxLength;
  final String errorMessage;
  final String helperText;
  final GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    controller.text = currentText;

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
            child: SimpleAutoCompleteTextField(
              key: key,
              suggestions: suggestions,
              controller: controller,
              textChanged: (siteName) {
                if (onTextChanged != null) onTextChanged(siteName);
              },
              style: TextStyle(fontSize: 17),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade400),
                helperStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: hint,
                helperText: helperText,
                labelText: secondaryMainText,
                focusColor: color_primary,
                errorText: errorMessage,
              ),
            ),
          )
        ],
      ),
    );
  }
}

//

//

//

//

//

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
