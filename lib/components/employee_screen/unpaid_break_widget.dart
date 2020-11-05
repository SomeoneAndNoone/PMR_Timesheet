import 'package:flutter/material.dart';

import '../custom_number_text_filed.dart';

class UnpaidBreakWidget extends StatelessWidget {
  const UnpaidBreakWidget({this.currentText, this.onTextChanged});

  final String currentText;
  final Function onTextChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomNumberTextField(
        mainText: 'Unpaid Break: ',
        hint: '60',
        suffix: 'mins',
        maxLength: 3,
        currentText: currentText,
        onTextChanged: (money) {
          onTextChanged(money);
        },
      ),
    );
  }
}
