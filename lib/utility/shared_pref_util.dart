import 'package:pmr_staff/constants/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setFullNameSharedPrefs(String fullName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(NAME_PREF_KEY, fullName);
}

Future<String> getFullNameSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(NAME_PREF_KEY);
}

Future<void> setPayrollEmailSharedPrefs(String newEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(PAYROLL_EMAIL_PREF_KEY, newEmail);
}

Future<String> getPayrollEmailSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String payrollAddress = prefs.getString(PAYROLL_EMAIL_PREF_KEY);
  if (payrollAddress == null) {
    return 'payroll@pmr.uk.com';
  }
  return payrollAddress;
}

Future<void> setAddressSharedPrefs(String newAddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(ADDRESS_PREF_KEY, newAddress);
}

Future<String> getAddressSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(ADDRESS_PREF_KEY);
}

Future<void> setStreetAddress(String newAddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(STREET_ADDRESS_KEY, newAddress);
}

Future<String> getStreetAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(STREET_ADDRESS_KEY);
}

Future<void> setCityName(String newAddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(CITY_NAME_KEY, newAddress);
}

Future<String> getCityName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(CITY_NAME_KEY);
}

Future<void> setPostCode(String newAddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(POST_CODE_KEY, newAddress);
}

Future<String> getPostCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(POST_CODE_KEY);
}

Future<void> setIsFirstTime(bool isFirstTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(IS_FIRST_TIME_KEY, isFirstTime);
}

Future<bool> getIsFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool(IS_FIRST_TIME_KEY);
  if (isFirstTime == null || isFirstTime) {
    return true;
  }
  return false;
}
