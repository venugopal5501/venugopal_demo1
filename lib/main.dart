import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';

class PDFGenerator extends StatefulWidget {
  @override
  _PDFGeneratorState createState() => _PDFGeneratorState();
}

class _PDFGeneratorState extends State<PDFGenerator> {
  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("asset/Latha.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Load the Tamil font using Google Fonts
    final tamilFont = GoogleFonts.notoSansTamil();

    // Add a page to the PDF
    pdf.addPage(pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Text(
            'நீங்கள் இருக்கும் அவல நிலைக்கு நீங்கள் மட்டுமே நன்றி சொல்ல வேண்டும்',
            style: pw.TextStyle(font: ttf, fontSize: 30),
          ),
        );
      },
    ));

    // Save the PDF to a Uint8List
    return pdf.save();
  }

  Future<void> _saveAndViewPdf(Uint8List pdfBytes) async {
    final blob = html.Blob([pdfBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = 'example.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Generator'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final pdfBytes = await generatePDF();
              await _saveAndViewPdf(pdfBytes);
            },
            child: Text('Download PDF'),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(PDFGenerator());
