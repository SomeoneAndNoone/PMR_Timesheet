import 'package:pmr_staff/constants/constants.dart';
import 'package:string_validator/string_validator.dart';

class AccountData {
  AccountData({
    this.fullName = '',
    this.payrollEmail = PAYROLL_EMAIL,
    this.cityName = '',
    this.address = '',
    this.streetAddress = '',
    this.postCode = '',
    this.fullNameError,
    this.payrollEmailError,
    this.cityNameError,
    this.streetAddressError,
    this.postCodeError,
  });

  bool isAnyErrorInAccount = false;
  String fullName;
  String payrollEmail;
  String cityName;
  String address;
  String streetAddress;
  String postCode;

  // Errors
  String fullNameError;
  String payrollEmailError;
  String cityNameError;
  String streetAddressError;
  String postCodeError;

  static AccountData checkAccountData(AccountData accountData) {
    accountData.isAnyErrorInAccount = false;

    print(accountData.fullName);
    // fullname is empty
    if (accountData.fullName == null || accountData.fullName.trim().isEmpty) {
      accountData.fullNameError = 'Name cannot be empty';
      accountData.isAnyErrorInAccount = true;
      print('1');
    } else if (!isAlpha(accountData.fullName.trim().replaceAll(' ', 'a'))) {
      accountData.fullNameError = 'Full name should contain only letters';
      print('2');
      accountData.isAnyErrorInAccount = true;
    } else {
      accountData.fullNameError = null;
    }

    // street address is empty
    if (accountData.streetAddress == null ||
        accountData.streetAddress.trim().isEmpty) {
      accountData.streetAddressError = 'Street address cannot be empty';
      print('3');
      accountData.isAnyErrorInAccount = true;
    } else {
      accountData.streetAddressError = null;
    }

    // city is empty
    if (accountData.cityName == null || accountData.cityName.trim().isEmpty) {
      accountData.cityNameError = 'City name cannot be empty';
      print('4');
      accountData.isAnyErrorInAccount = true;
    } else {
      accountData.cityNameError = null;
    }

    // postcode is empty
    if (accountData.postCode == null || accountData.postCode.trim().isEmpty) {
      accountData.postCodeError = "Postcode cannot be empty";
      print('5');
      accountData.isAnyErrorInAccount = true;
    } else {
      accountData.postCodeError = null;
    }

    if (accountData.payrollEmail == null ||
        accountData.payrollEmail.trim().isEmpty) {
      accountData.payrollEmailError = 'Payroll email cannot be empty';
      print('6');
      accountData.isAnyErrorInAccount = true;
    } else {
      accountData.payrollEmailError = null;
    }

    print('isError=${accountData.isAnyErrorInAccount}');
    return accountData;
  }
}
