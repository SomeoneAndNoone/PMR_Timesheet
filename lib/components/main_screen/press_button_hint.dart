import 'package:flutter/material.dart';

class PressButtonHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: 150,
        ),
        Column(
          children: [
            Text(
              'Add new shift',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 23),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Press',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 25),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
