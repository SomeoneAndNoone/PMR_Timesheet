import 'package:flutter/material.dart';
import 'package:pmr_staff/components/custom_edit_text.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/account_data.dart';
import 'package:pmr_staff/screens/main_screen.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:pmr_staff/utility/ui_functions.dart';
import 'package:url_launcher/url_launcher.dart';

const String pmrRegistrationUrl = 'https://www.pmr.uk.com';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  AccountData accountData = AccountData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 70),
          Center(
            child: GestureDetector(
              onTap: () async {
                if (await canLaunch(pmrRegistrationUrl))
                  await launch(pmrRegistrationUrl);
              },
              child: Image(
                image: AssetImage('assets/registration.png'),
                height: 120,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                if (await canLaunch(pmrRegistrationUrl))
                  await launch(pmrRegistrationUrl);
              },
              child: Text(
                'Don\'t you work for PMR?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          CustomEditText(
            mainText: 'Full Name',
            hint: 'e.g. John Hopper',
            maxLength: 50,
            currentText: accountData.fullName,
            errorMessage: accountData.fullNameError,
            onTextChanged: (newFullName) {
              accountData.fullName = newFullName;
            },
          ),
          CustomEditText(
            mainText: 'Street Address',
            hint: 'e.g. 342 Chrisp Street',
            maxLength: 50,
            errorMessage: accountData.streetAddressError,
            currentText: accountData.streetAddress,
            onTextChanged: (newStreetAddress) {
              accountData.streetAddress = newStreetAddress;
            },
          ),
          CustomEditText(
            mainText: 'City',
            hint: 'e.g. London',
            maxLength: 30,
            currentText: accountData.cityName,
            errorMessage: accountData.cityNameError,
            onTextChanged: (newCity) {
              accountData.cityName = newCity;
            },
          ),
          CustomEditText(
            mainText: 'Postcode',
            hint: 'e.g. E10 6PX',
            maxLength: 10,
            currentText: accountData.postCode,
            errorMessage: accountData.postCodeError,
            onTextChanged: (newPostcode) {
              accountData.postCode = newPostcode;
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                accountData = AccountData.checkAccountData(accountData);
                if (!accountData.isAnyErrorInAccount) {
                  showAlertDialog(
                    context,
                    'Info',
                    'Are you sure to save all info? This might be sent to PMR with your shifts!',
                    'OK',
                    'CANCEL',
                    () async {
                      await saveData();
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/'),
                      );
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MainScreen();
                      }));
                    },
                  );
                } else {
                  setState(() {});
                }
              },
              color: color_primary,
              child: Text(
                'DONE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveData() async {
    accountData.address =
        '${accountData.streetAddress},\n${accountData.cityName}, ${accountData.postCode}'
            .trim();
    await setAddressSharedPrefs(accountData.address);
    await setFullNameSharedPrefs(accountData.fullName.trim());
    await setCityName(accountData.cityName);
    await setStreetAddress(accountData.streetAddress);
    await setPostCode(accountData.postCode);
    await setIsFirstTime(false);
  }
}
// full name
// address
//
