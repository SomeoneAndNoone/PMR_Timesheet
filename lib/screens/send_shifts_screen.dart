import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pmr_staff/components/send_shifts/pdf_shifts_component.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/controller/database_helper.dart';
import 'package:pmr_staff/models/db/shift_group.dart';
import 'package:pmr_staff/models/db/single_shift.dart';
import 'package:pmr_staff/models/pdf_models/single_site_pdf_model.dart';
import 'package:pmr_staff/models/pdf_models/single_summary_content.dart';
import 'package:pmr_staff/screens/file_utility.dart';
import 'package:pmr_staff/utility/data_utils.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:printing/printing.dart';

class SendShiftsScreen extends StatefulWidget {
  SendShiftsScreen({this.scheduledShifts});

  final List<ShiftGroupModel> scheduledShifts;

  @override
  _SendShiftsScreenState createState() => _SendShiftsScreenState();
}

class _SendShiftsScreenState extends State<SendShiftsScreen> {
  List<ShiftGroupModel> scheduledShiftGroups = [];
  List<List<SingleShiftModel>> allScheduledShifts = [];
  List<SingleSitePdfModel> sitesPdfModel = [];
  List<SingleSummaryContent> shiftGroupsForSummary = [];
  List<String> workedHoursForEachSite = [];

  @override
  void initState() {
    super.initState();
    scheduledShiftGroups = widget.scheduledShifts;
  }

  void _showSharedToast(BuildContext context) {
    // showSnackbar(context, 'Document shared successfully');
  }

  Future<void> saveAsFileAndSend(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    String path =
        await savePdfAsFile(context, build, pageFormat, await getPdfName());
    sendViaMail(path);
  }

  Future<String> getPdfName() async {
    String name = (await getFullNameSharedPrefs()).replaceAll(' ', '_');
    String date =
        getDD_MM_YYYYfromMillisecs(DateTime.now().millisecondsSinceEpoch);
    return '${name}_$date';
  }

  @override
  Widget build(BuildContext context) {
    final actions = <PdfPreviewAction>[
      PdfPreviewAction(
        icon: const Icon(Icons.send),
        onPressed: saveAsFileAndSend,
      )
    ];

    return Theme(
      isMaterialAppTheme: true,
      data: Theme.of(context).copyWith(primaryColor: color_accent),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shifts Preview',
              style: TextStyle(color: Colors.white)),
          backgroundColor: color_accent,
        ),
        body: PdfPreview(
          maxPageWidth: 700,
          build: generateShifts,
          actions: actions,
          canChangePageFormat: false,
          onShared: _showSharedToast,
          allowPrinting: false,
        ),
      ),
    );
  }

  Future<Uint8List> generateShifts(PdfPageFormat pageFormat) async {
    await generateNecessaryVars();

    final timeSheet = TimeSheet(
      totalHours: getTotalHours(),
      shiftGroupsForSummary: shiftGroupsForSummary,
      sitesPdfModel: sitesPdfModel,
      employeeName: await getFullNameSharedPrefs(),
      staffAddress: '147 Chrisp Street,\nPoplar, London, E14 6NH',
    );

    PdfPageFormat mPageFormat = PdfPageFormat.a4;
    return await timeSheet.buildPdf(mPageFormat);
  }

  void generateNecessaryVars() async {
    await generateAllScheduledShifts();

    await generateAllWorkedShifts();

    await generateShiftGroupsForSummary();
  }

  void generateAllScheduledShifts() async {
    if (allScheduledShifts.isNotEmpty) return;
    allScheduledShifts = [];
    for (int i = 0; i < scheduledShiftGroups.length; i++) {
      ShiftGroupModel shiftGroup = scheduledShiftGroups[i];
      List<SingleShiftModel> aGroupList = await DbInstance.dbHelper
          .getShiftModelsForParticularGroup(shiftGroup.uniqueGroupId);
      allScheduledShifts.add(aGroupList);
    }
  }

  void generateAllWorkedShifts() async {
    if (sitesPdfModel.isNotEmpty) return;
    sitesPdfModel = [];
    workedHoursForEachSite = [];
    String pmrStaffName = await getFullNameSharedPrefs();

    for (int i = 0; i < allScheduledShifts.length; i++) {
      List<SingleShiftModel> aWeekShifts = allScheduledShifts[i];

      // generates 7 shifts from monday to sunday
      List<SingleShiftForSingleSitePdf> singleSiteShifts =
          SingleShiftForSingleSitePdf.generateShiftsForAllWeek();
      double totalHoursForTheWeek = 0;

      aWeekShifts.forEach((aShift) {
        int index = getWeekdayFromZero(aShift.date);
        singleSiteShifts[index].comments = aShift.comment;

        singleSiteShifts[index].totalWorkedHrs =
            getFormattedDouble(aShift.workedHours);

        singleSiteShifts[index].breakTime =
            convertMinToHour(aShift.breakTimeInMins);

        singleSiteShifts[index].stTime =
            getHHMM12FromMillisecs(aShift.startTime);

        singleSiteShifts[index].endTime =
            getHHMM12FromMillisecs(aShift.endTime);

        singleSiteShifts[index].shiftDate = getDDMMfromMillisecs(aShift.date);

        totalHoursForTheWeek += aShift.workedHours;
      });

      workedHoursForEachSite.add(getFormattedDouble(totalHoursForTheWeek));

      sitesPdfModel.add(
        SingleSitePdfModel(
          totalHours: getFormattedDouble(totalHoursForTheWeek),
          weekEnding: getDDMMfromMillisecs(scheduledShiftGroups[i].weekEnding),
          permStaffName: scheduledShiftGroups[i].permStaffName,
          pmrStaffName: pmrStaffName,
          pngBytesInString: scheduledShiftGroups[i].pngSignatureBytesInStr,
          position: scheduledShiftGroups[i].jobPosition,
          workedShifts: singleSiteShifts,
          siteName: scheduledShiftGroups[i].name,
        ),
      );
    }
  }

  void generateShiftGroupsForSummary() {
    if (shiftGroupsForSummary.isNotEmpty) return;
    shiftGroupsForSummary = [];
    for (int i = 0; i < scheduledShiftGroups.length; i++) {
      ShiftGroupModel groupModel = scheduledShiftGroups[i];
      shiftGroupsForSummary.add(
        SingleSummaryContent(
          getDDMMfromMillisecs(groupModel.weekEnding),
          groupModel.name,
          workedHoursForEachSite[i],
          groupModel.jobPosition,
        ),
      );
    }
  }

  int getWeekdayFromZero(int dateSecs) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateSecs);
    return date.weekday - 1;
  }

  String getTotalHours() {
    double totalHours = 0;
    allScheduledShifts.forEach((shiftGroup) {
      shiftGroup.forEach((element) {
        totalHours += element.workedHours;
      });
    });

    return '${getFormattedDouble(totalHours)}';
  }
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
