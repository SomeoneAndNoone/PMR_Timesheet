import 'package:flutter/material.dart';

void showAlertDialog(
  BuildContext context,
  String title,
  String des,
  String positiveBtnTxt,
  String negativeBtnTxt,
  Function positiveAction,
) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(negativeBtnTxt),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(positiveBtnTxt),
    onPressed: positiveAction,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(des),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showSnackbar(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}
