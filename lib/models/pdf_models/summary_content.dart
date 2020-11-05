import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pmr_staff/models/pdf_models/pdf_style_content.dart';
import 'package:pmr_staff/models/pdf_models/single_summary_content.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pmr_staff/utility/data_utils.dart';

class SummaryPdfContent {
  SummaryPdfContent({
    @required this.pageTheme,
    @required this.logo,
    @required this.staffName,
    @required this.staffAddress,
    @required this.sendingDate,
    @required this.totalHours,
    @required this.shiftSummaries,
  });

  final PdfImage logo;
  final pw.PageTheme pageTheme;
  final String staffName;
  final String staffAddress;
  final DateTime sendingDate;
  final String totalHours;
  final List<SingleSummaryContent> shiftSummaries;

  pw.MultiPage buildAndGetSummaryPdfPage() {
    return pw.MultiPage(
      pageTheme: pageTheme,
      header: _buildHeader,
      footer: _buildFooter,
      build: (context) => [
        _contentHeader(context),
        _contentTable(context),
        pw.SizedBox(height: 20),
        _pleaseNote(context),
        pw.SizedBox(height: 20),
        _contactInfo(context),
        pw.SizedBox(height: 10),
      ],
    );
  }

  // Header
  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text(
                      'TimeSheet',
                      style: pw.TextStyle(
                        color: PdfStyle.pdfBaseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius: 2,
                      color: PdfStyle.pdfAccentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: PdfStyle.pdfBaseTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text(
                            'Total hours: ',
                          ),
                          pw.Text(totalHours),
                          pw.Text('Sent Date:'),
                          pw.Text(formatDateInYMMMD(sendingDate)),
                        ],
                      ),
                    ),
                  ),
                ],
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
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                '$staffName',
                style: pw.TextStyle(
                  color: PdfStyle.pdfBaseColor,
                  fontSize: 35,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Staff Address:',
                  style: pw.TextStyle(
                    color: PdfStyle.pdfDarkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.Text(
                    staffAddress,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Content
  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'W/E',
      'Site Name',
      'Hours',
      'Position',
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
        color: PdfStyle.pdfBaseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        color: PdfStyle.pdfBaseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfStyle.pdfDarkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          color: PdfStyle.pdfAccentColor,
          width: .5,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        shiftSummaries.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => shiftSummaries[row].getIndex(col),
        ),
      ),
    );
  }

  // Footer
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data:
                'TimeSheet: $staffName, Total Hours: $totalHours, Date: ${formatDateInYMMMD(sendingDate)}',
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ),
      ],
    );
  }

  pw.Widget _contactInfo(pw.Context context) {
    return pw.Container(
      child: pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  top: true,
                  color: PdfStyle.pdfAccentColor,
                ),
              ),
              padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
              child: pw.Text(
                'Contact Info',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfStyle.pdfBaseColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              _contactInfoText,
              textAlign: pw.TextAlign.justify,
              style: const pw.TextStyle(
                fontSize: 6,
                lineSpacing: 2,
                color: PdfStyle.pdfDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _pleaseNote(pw.Context context) {
    return pw.Expanded(
      flex: 2,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                'Please Note',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfStyle.pdfBaseColor,
                  fontStyle: pw.FontStyle.italic,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.Text(
            _mustBeSignedText,
            style: pw.TextStyle(
              fontSize: 8,
              lineSpacing: 1,
              // fontWeight: pw.FontWeight.bold,
              color: PdfStyle.pdfAccentColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            _termsAndConditionsText,
            style: const pw.TextStyle(
              fontSize: 8,
              lineSpacing: 2,
              color: PdfStyle.pdfDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  final String _contactInfoText =
      'Address: 50 Eastcastle Street, London W1W 8EA\nTel: 0207 436 0360 Fax: 0207 691 7358\nWeb: www.pmr.uk.com';
  final String _mustBeSignedText =
      'FAILURE TO HAVE YOUR TIMESHEET SIGNED BY AN AUTHORISED SITE SIGNATORY MAY RESULT IN NON PAYMENT OF YOUR WAGES\n';
  final String _termsAndConditionsText = """
Please ensure that your timesheet is completed with the correct dates and times of your shift(s)

Employees are paid on a 2 weekly basis on a Friday. Timesheets should be submitted to the PMR payroll department on Monday before 13:00 hours in order for payment to credit bank accounts the following Friday.

Timesheets received after this time will not be processed within this payroll and will be held until the next available payroll.

Please submit your signed timesheet to payroll@pmr.uk.com
Alternatively please fax your timesheet(s) to 0207 691 7358
  """;
}
