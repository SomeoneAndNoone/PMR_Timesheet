import 'package:flutter/foundation.dart';

class EmployerInputData extends ChangeNotifier {
  bool _isDescriptionConfirmed = false;
  bool _isSignatureConfirmed = false;
  String _employerFullName;

  void setDescriptionConfrimed(bool isDesConfirmed) {
    _isDescriptionConfirmed = isDesConfirmed;
  }

  bool getIsDescriptionConfirmed() => _isDescriptionConfirmed;

  void setIsSignatureConfirmed(bool isSignatureConfirmed) {
    _isSignatureConfirmed = isSignatureConfirmed;
  }

  bool getIsSignatureConfirmed() => _isSignatureConfirmed;

  void setFullName(String fullName) {
    _employerFullName = fullName;
  }

  String getFullName() => _employerFullName;
}
