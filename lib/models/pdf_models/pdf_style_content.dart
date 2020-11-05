import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

class PdfStyle {
  static const pdfDarkColor = PdfColors.blueGrey800;
  static const pdfLightColor = PdfColors.white;
  static PdfColor pdfBaseColor = PdfColor.fromHex('c761a6');
  static PdfColor pdfBlackColor = PdfColor.fromHex('000000');
  static PdfColor pdfAccentColor = PdfColor.fromHex('1a386f');
  static PdfColor pdfBaseTextColor =
      pdfBaseColor.luminance < 0.5 ? pdfLightColor : pdfDarkColor;
  static PdfColor accentTextColor =
      pdfAccentColor.luminance < 0.5 ? pdfLightColor : pdfDarkColor;
  static PdfColor pdfGreyColor = pdfAccentColor;

  ByteData _font1;
  ByteData _font2;
  ByteData _font3;

  Future<void> loadFonts() async {
    _font1 = await rootBundle.load('assets/roboto1.ttf');
    _font2 = await rootBundle.load('assets/roboto2.ttf');
    _font3 = await rootBundle.load('assets/roboto3.ttf');
  }

  Future<Uint8List> loadLogo() async {
    var logoBytes =
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List();
    return logoBytes;
  }

  Font getFont1() {
    return _font1 != null ? pw.Font.ttf(_font1) : null;
  }

  Font getFont2() {
    return _font2 != null ? pw.Font.ttf(_font2) : null;
  }

  Font getFont3() {
    return _font3 != null ? pw.Font.ttf(_font3) : null;
  }
}
