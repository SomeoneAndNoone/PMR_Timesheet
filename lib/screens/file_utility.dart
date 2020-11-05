import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pmr_staff/utility/shared_pref_util.dart';
import 'package:printing/printing.dart';

Future<String> savePdfAsFile(
  BuildContext context,
  LayoutCallback build,
  PdfPageFormat pageFormat,
  String pdfDocName,
) async {
  final Uint8List bytes = await build(pageFormat);

  final Directory appDocDir = await getTemporaryDirectory();
  final String appDocPath = appDocDir.path;
  final File file = File(appDocPath + '/' + '$pdfDocName.pdf');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<void> sendViaMail(String attachmentPath) async {
  final Email email = Email(
    body: getTableForEmailBody(),
    subject: 'Timesheet for ${await getFullNameSharedPrefs()}',
    recipients: [
      // '${await getPayrollEmailSharedPrefs()}'
    ],
    cc: [],
    bcc: [],
    attachmentPaths: [
      attachmentPath,
    ],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}

String getTableForEmailBody() {
  return """
Hi,
                                                                                                
Please, find the attached file about shifts I worked!
""";
}
