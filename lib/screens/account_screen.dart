import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_edit_text.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/account_data.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountData accountData = AccountData();

  @override
  void initState() {
    super.initState();

    getNames().then((value) {
      setState(() {});
    });
  }

  Future<void> getNames() async {
    accountData = AccountData(
      fullName: await getFullNameSharedPrefs(),
      address: await getAddressSharedPrefs(),
      payrollEmail: await getPayrollEmailSharedPrefs(),
      streetAddress: await getStreetAddressKey(),
      postCode: await getPostCode(),
      cityName: await getCityName(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: color_accent,
      ),
      body: Builder(
        builder: (context) => ListView(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20),
            CustomEditText(
              mainText: 'Temp Staff Name',
              hint: 'e.g. John Hopper',
              maxLength: 50,
              onTextChanged: (newValue) {
                accountData.fullName = newValue;
              },
              errorMessage: accountData.fullNameError,
              currentText: accountData.fullName,
            ),
            CustomEditText(
              mainText: 'Payroll Email',
              hint: 'payroll@pmr.co.uk',
              onTextChanged: (newValue) {
                accountData.payrollEmail = newValue;
              },
              errorMessage: accountData.payrollEmailError,
              maxLength: 50,
              currentText: accountData.payrollEmail,
            ),
            CustomEditText(
              mainText: 'Street Address',
              hint: 'e.g 232 Bolton Road',
              maxLength: 50,
              errorMessage: accountData.streetAddressError,
              onTextChanged: (newValue) {
                accountData.streetAddress = newValue;
              },
              currentText: accountData.streetAddress,
            ),
            CustomEditText(
              mainText: 'City',
              hint: 'e.g. London',
              errorMessage: accountData.cityNameError,
              onTextChanged: (newValue) {
                accountData.cityName = newValue;
              },
              maxLength: 50,
              currentText: accountData.cityName,
            ),
            CustomEditText(
              mainText: 'Postcode',
              errorMessage: accountData.postCodeError,
              hint: 'e.g. E32 4PU',
              onTextChanged: (newValue) {
                accountData.postCode = newValue;
              },
              maxLength: 50,
              currentText: accountData.postCode,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: MaterialButton(
                onPressed: () {
                  accountData = AccountData.checkAccountData(accountData);
                  setState(() {});
                  if (!accountData.isAnyErrorInAccount) {
                    showAlertDialog(
                      context,
                      'Warning!!!',
                      'Are you sure to save?',
                      'Yes',
                      'No',
                      () async {
                        await saveData();
                        Navigator.pop(context);
                        showSnackbar(context, 'Saved Successfully');
                      },
                    );
                  }
                },
                color: color_accent,
                child: Text(
                  'SAVE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveData() async {
    accountData.address =
        '${accountData.streetAddress},\n${accountData.cityName}, ${accountData.postCode}'
            .trim();
    await setAddressSharedPrefs(accountData.address.trim());
    await setFullNameSharedPrefs(accountData.fullName.trim());
    await setCityName(accountData.cityName.trim());
    await setStreetAddress(accountData.streetAddress.trim());
    await setPostCode(accountData.postCode.trim());
  }
}
