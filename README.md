import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

Future<void> printLocalPDFWithDuplex(String path, Printer printer) async {
try {
// 1. اقرأ ملف PDF من الجهاز
Uint8List pdfBytes = await File(path).readAsBytes();

    // 2. اطبع باستخدام الطابعة المختارة
    await Printing.directPrintPdf(
      printer: printer,
      onLayout: (PdfPageFormat format) async => pdfBytes,
      usePrinterSettings: true,
    );

    print('✅ PDF sent to printer successfully!');
    Get.snackbar('Success', 'PDF sent to printer successfully!');

} catch (e) {
print('❌ Failed to print PDF: $e');
Get.snackbar('Error', 'Failed to print PDF: $e');
}
}
# printoo
# printoo
