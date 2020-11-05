import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pmr_staff/models/pdf_models/pdf_style_content.dart';
import 'package:pmr_staff/models/pdf_models/single_site_content.dart';
import 'package:pmr_staff/models/pdf_models/single_site_pdf_model.dart';
import 'package:pmr_staff/models/pdf_models/single_summary_content.dart';
import 'package:pmr_staff/models/pdf_models/summary_content.dart';
import 'package:pmr_staff/utility/point_converter.dart';
import 'package:signature/signature.dart';

class TimeSheet {
  TimeSheet({
    // summary content
    this.shiftGroupsForSummary,
    this.employeeName,
    this.staffAddress,
    this.totalHours,
    // main time sheet content
    this.sitesPdfModel,
  });

  // summary content
  final List<SingleSummaryContent> shiftGroupsForSummary;
  final String employeeName;
  final String staffAddress;
  final String totalHours;
  // main time sheet content
  final List<SingleSitePdfModel> sitesPdfModel;

  PdfImage _logo;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();
    final pdfStyle = PdfStyle();
    await pdfStyle.loadFonts();
    _logo = PdfImage.file(
      doc.document,
      bytes: await pdfStyle.loadLogo(),
    );

    pw.PageTheme pageTheme = _buildTheme(
      pageFormat,
      pdfStyle.getFont1(),
      pdfStyle.getFont2(),
      pdfStyle.getFont3(),
    );

    // insert summary content
    SummaryPdfContent summary = SummaryPdfContent(
      pageTheme: pageTheme,
      logo: _logo,
      staffName: employeeName,
      staffAddress: staffAddress,
      sendingDate: DateTime.now(),
      totalHours: totalHours,
      shiftSummaries: shiftGroupsForSummary,
    );

    doc.addPage(summary.buildAndGetSummaryPdfPage());
    for (int i = 0; i < sitesPdfModel.length; i++) {
      SingleSitePdfModel singleSite = sitesPdfModel[i];

      SingleSitePdfContent singleSitePdf = SingleSitePdfContent(
        logo: _logo,
        pageTheme: pageTheme,
        singleSitePdfModel: singleSite,
      );

      var pngBytes = await getPngBytes(singleSite.pngBytesInString);
      PdfImage signatureImage = PdfImage.file(doc.document, bytes: pngBytes);

      doc.addPage(singleSitePdf.buildAndGetMainSheet(signatureImage));
    }

    return doc.save();
  }

  Future<Uint8List> getPngBytes(String pngBytesStr) async {
    List<Point> points = convertStrToPoints(pngBytesStr);
    SignatureController controller = SignatureController(
      points: points,
      exportBackgroundColor: Colors.grey.shade100,
    );

    return await controller.toPngBytes();
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              bottom: 0,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 2,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfStyle.pdfBaseColor, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              bottom: 20,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 4,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfStyle.pdfAccentColor, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              top: pageFormat.marginTop + 72,
              left: 0,
              right: 0,
              child: pw.Container(
                height: 3,
                color: PdfStyle.pdfBaseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
