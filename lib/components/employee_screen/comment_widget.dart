import 'package:flutter/material.dart';
import 'package:pmr_staff/constants/colors.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({
    @required this.mainText,
    @required this.hint,
    @required this.maxLength,
    @required this.onCommentChanged,
    this.isEditable = true,
    this.helperText,
    this.secondaryMainText,
    this.errorMessage,
    this.currentText,
  });

  Function onCommentChanged;
  final bool isEditable;
  final String secondaryMainText;
  final String mainText;
  final String currentText;
  final String hint;
  final int maxLength;
  final String errorMessage;
  final String helperText;

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
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              enabled: isEditable,
              controller: TextEditingController()..text = currentText,
              onChanged: onCommentChanged,
              style: TextStyle(fontSize: 17),
              maxLength: maxLength,
              cursorColor: color_primary,
              decoration: InputDecoration(
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
