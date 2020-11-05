import 'package:flutter/material.dart';
import 'package:pmr_staff/constants/colors.dart';

class StepsComponent extends StatelessWidget {
  StepsComponent({@required this.currentStep});

  final int currentStep;
  final activeColor = color_primary;

  @override
  Widget build(BuildContext context) {
    Color step1Color = Colors.grey;
    Color step2Color = Colors.grey;
    Color step3Color = Colors.grey;

    if (currentStep == 1) {
      step1Color = activeColor;
    } else if (currentStep == 2) {
      step2Color = activeColor;
    } else if (currentStep == 3) {
      step3Color = activeColor;
    } else {
      throw 'Current step must be 1, 2 or 3';
    }
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Material(
                  color: step1Color,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '1',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'PMR Staff',
                    style: TextStyle(color: step1Color),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Container(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
            ),
            Column(
              children: [
                Material(
                  color: step2Color,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '2',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Permanent',
                    style: TextStyle(color: step2Color),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Container(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
            ),
            Column(
              children: [
                Material(
                  color: step3Color,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '3',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Thank you!',
                    style: TextStyle(color: step3Color),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
