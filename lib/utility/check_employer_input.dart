import 'package:pmr_staff/models/employer_signin/employer_data.dart';

String checkEmployerInput(EmployerInputData data) {
  String error = '';

  if (!data.getIsDescriptionConfirmed()) {
    error = 'Shift must be confirmed';
  }

  if (!data.getIsSignatureConfirmed()) {
    if (error != '') {
      error += ', ';
    }
    error += 'Must be signed';
  }

  if (data.getFullName() == null || data.getFullName().isEmpty) {
    if (error != '') {
      error += ', ';
    }
    error += 'Perm Staff Full Name cannot be empty';
  }

  return error;
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
