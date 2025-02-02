import 'package:mob4/utils/app_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/candidate.dart';
import '../models/test_models.dart';

import 'package:flutter/services.dart';


class GenerateTestPdf {
  static Future<void> generatePdf(Candidate candidate, Test test) async {
    final pdf = pw.Document();

    // Charger le logo
    final ByteData data = await rootBundle.load('images/logo.png');
    final Uint8List logoBytes = data.buffer.asUint8List();

    final List<String> remarksText = test.remarks.map((remarkId){
      var remark = AppData.remarks.firstWhere((element) => element.remarkId == remarkId);
      return remark.text;
    }).toList();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(pw.MemoryImage(logoBytes), width: 60),
                  pw.Text(
                    'Test Report',
                    style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              _buildSectionTitle("Candidate Information"),
              _buildInfoRow("Name", "${candidate.otherNames} ${candidate.lastName}"),
              _buildInfoRow("Email", candidate.email),
              _buildInfoRow("Phone", candidate.phone),
              pw.SizedBox(height: 20),

              // Informations du test
              _buildSectionTitle("Test Details"),
              _buildInfoRow("Test ID", test.testId),
              _buildInfoRow("Date", test.date),
              _buildInfoRow("Vehicle", test.vehicleNo),
              _buildInfoRow("Route", test.route),
              _buildInfoRow("Start Time", test.startTime),
              _buildInfoRow("End Time", test.endTime ?? "Not yet completed"),
              _buildInfoRow("Note", test.note ?? ""),
              pw.SizedBox(height: 20),

              // Remarques s'il y en a
              if (remarksText.isNotEmpty) _buildSectionTitle("Remarks"),
              if (remarksText.isNotEmpty)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    remarksText.join(",\n"),
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ),

              pw.Spacer(),

              // Pied de page
              pw.Divider(),
              pw.Text(
                "This is an automatically generated report. If you have any questions, please contact us.",
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    // Afficher le PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Fonction pour créer une section de titre
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
      ),
    );
  }

  // Fonction pour afficher une ligne d'information
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
