import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/constants/screen_ids.dart';
import 'package:pmr_staff/screens/account_screen.dart';
import 'package:pmr_staff/screens/employee_signin_screen.dart';
import 'package:pmr_staff/screens/employer_signin_screen.dart';
import 'package:pmr_staff/screens/history_screen.dart';
import 'package:pmr_staff/screens/main_screen.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/screens/registration_screen.dart';
import 'package:pmr_staff/utility/notificatins_util.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

bool isFirstTime;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done

Future<void> main() async {
  // this is to prevent bugs
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectNotificationSubject.add(payload);
  });

  // initialize db globally
  DbInstance.dbHelper = DatabaseHelperImpl();

  isFirstTime = await getIsFirstTime();

  runApp(PmrTimesheet(
    notificationAppLaunchDetails,
  ));
}

class PmrTimesheet extends StatefulWidget {
  const PmrTimesheet(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _PmrTimesheetState createState() => _PmrTimesheetState();
}

class _PmrTimesheetState extends State<PmrTimesheet> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions(flutterLocalNotificationsPlugin);
    configureDidReceiveLocalNotificationSubject(
        didReceiveLocalNotificationSubject, context);
    configureSelectNotificationSubject(selectNotificationSubject);
    scheduleWeeklyMondayTenAMNotification();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        accentColor: color_accent,
        primaryColor: color_primary,
      ),
      initialRoute: isFirstTime ? registration_screen_id : main_screen_id,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case employer_signin_screen_id:
            return (PageTransition(
                child: EmployerSignInScreen(),
                type: PageTransitionType.rightToLeft));
          default:
            return null;
        }
      },
      routes: {
        main_screen_id: (context) => MainScreen(),
        registration_screen_id: (context) => RegistrationScreen(),
        employee_signin_screen_id: (context) => EmployeeSigninScreen(),
        employer_signin_screen_id: (context) => EmployerSignInScreen(),
        account_screen_id: (context) => AccountScreen(),
        history_screen_id: (context) => HistoryScreen(),
        // add_new_shift_screen_id: (context) => AddNewShiftScreen()
      },
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
