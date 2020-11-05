import 'package:flutter/material.dart';
import 'package:pmr_staff/constants/colors.dart';

class InfoAlertDialog extends StatelessWidget {
  InfoAlertDialog({@required this.title, @required this.bodyText});

  final String title;
  final String bodyText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: color_accent),
      ),
      content: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              bodyText,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: color_primary),
                  textAlign: TextAlign.end,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
