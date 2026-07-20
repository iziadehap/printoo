import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<int> getPageCount(String pdfPath) async {
  try {
    final fileBytes = File(pdfPath).readAsBytesSync();

  final document = PdfDocument(inputBytes: fileBytes);
  int pageCount = document.pages.count;

  document.dispose();

  return pageCount;
  } catch (e) {
    print('error in getPageCount: ');
    return 0;
  }
}
