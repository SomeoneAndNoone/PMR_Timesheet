import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pmr_staff/constants/colors.dart';
import 'package:pmr_staff/models/pdf_models/pdf_style_content.dart';
import 'package:pmr_staff/models/pdf_models/single_site_pdf_model.dart';
import 'package:pmr_staff/utility/point_converter.dart';
import 'package:signature/signature.dart';

class SingleSitePdfContent {
  SingleSitePdfContent({
    @required this.logo,
    @required this.pageTheme,
    @required this.singleSitePdfModel,
  });

  final PdfImage logo;
  final pw.PageTheme pageTheme;
  final SingleSitePdfModel singleSitePdfModel;

  pw.MultiPage buildAndGetMainSheet(PdfImage signatureImage) {
    return pw.MultiPage(
      pageTheme: pageTheme,
      header: _buildHeader,
      build: (context) => [
        _contentHeader(context),
        _contentTable(context),
        _contentTotal(context),
        _contentStaffName(context),
        pw.SizedBox(height: 30),
        _contentSignature(context, signatureImage),
      ],
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Container(
                alignment: pw.Alignment.topLeft,
                padding: const pw.EdgeInsets.only(
                  top: 15,
                ),
                height: 72,
                child: pw.Text(
                  'TimeSheet',
                  style: pw.TextStyle(
                    color: PdfStyle.pdfBaseColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child: logo != null ? pw.Image(logo) : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
          ],
        ),
        // pw.SizedBox(height: 10)
      ],
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            // column 1
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Site Name: '),
                  pw.SizedBox(height: 8),
                  pw.Text('Employee Name: '),
                  pw.SizedBox(height: 8),
                  pw.Text('Week ending Sunday: '),
                  pw.SizedBox(height: 8),
                  pw.Text('Job Position: '),
                ],
              ),
            ),
            // column 2
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  _singleLineUnderlinedWidget(singleSitePdfModel.siteName),
                  pw.SizedBox(height: 8),
                  _singleLineUnderlinedWidget(singleSitePdfModel.pmrStaffName),
                  pw.SizedBox(height: 8),
                  _singleLineUnderlinedWidget(singleSitePdfModel.weekEnding),
                  pw.SizedBox(height: 8),
                  _singleLineUnderlinedWidget(
                      singleSitePdfModel.position.toString()),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _singleLineUnderlinedWidget(String text) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          width: 1,
          // color: PdfStyle.pdfGreyColor,
        ),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfStyle.pdfAccentColor,
          fontWeight: pw.FontWeight.bold,
          fontStyle: pw.FontStyle.italic,
        ),
      ),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SHIFT DATE',
      'DAY',
      'START\nTIME',
      'BREAK',
      'END\nTIME',
      'TOTAL\nHOURS\nWORKED',
      'COMMENTS',
    ];

    return pw.Table.fromTextArray(
      border: pw.TableBorder(),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
        color: PdfStyle.pdfBaseColor,
      ),
      headerHeight: 25,
      cellHeight: 30,
      columnWidths: {
        0: pw.FlexColumnWidth(2), // shift date
        1: pw.FlexColumnWidth(2), // day
        2: pw.FlexColumnWidth(2), // st time
        3: pw.FlexColumnWidth(2), // break
        4: pw.FlexColumnWidth(2), // end time
        5: pw.FlexColumnWidth(2), // total hours
        6: pw.FlexColumnWidth(6), // comments
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        color: PdfStyle.pdfBaseTextColor,
        fontSize: 10,
        fontStyle: pw.FontStyle.italic,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfStyle.pdfDarkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          // bottom: true,
          color: PdfStyle.pdfAccentColor,
          width: .2,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        singleSitePdfModel.workedShifts.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => singleSitePdfModel.workedShifts[row].getIndex(col),
        ),
      ),
    );
  }

  pw.Widget _contentTotal(pw.Context context) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 5,
              child: pw.Text(
                'TOTAL',
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Row(
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                        border: pw.BoxBorder(
                            left: true, right: true, top: true, bottom: true)),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: pw.Text(
                        '${singleSitePdfModel.totalHours}',
                        style: pw.TextStyle(color: PdfStyle.pdfAccentColor),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _contentStaffName(context) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text('Permanent Staff:       '),
            pw.Text(
              singleSitePdfModel.permStaffName,
              style: pw.TextStyle(color: PdfStyle.pdfAccentColor),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _contentSignature(context, signatureImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Signature:",
            style: pw.TextStyle(color: PdfStyle.pdfBlackColor)),
        pw.SizedBox(width: 100),
        pw.Container(
          // color: PdfColors.grey,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(0),
            child: pw.Image(
              signatureImage,
              width: 400,
              height: 100,
            ),
          ),
        ),
      ],
    );
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
