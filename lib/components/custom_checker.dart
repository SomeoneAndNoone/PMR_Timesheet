import 'package:flutter/material.dart';

class CustomChecker extends StatefulWidget {
  CustomChecker(
      {this.checkboxText = 'Set as today\'s date', this.onCheckChanged});

  final checkboxText;
  Function onCheckChanged;

  @override
  _CustomCheckerState createState() => _CustomCheckerState();
}

class _CustomCheckerState extends State<CustomChecker> {
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Checkbox(
              value: checkboxValue,
              onChanged: (newValue) {
                setState(() {
                  checkboxValue = newValue;
                  widget.onCheckChanged(newValue);
                });
              },
            ),
            Text(widget.checkboxText),
          ],
        ),
      ),
    );
  }
}
