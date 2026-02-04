// ignore: file_names
import 'package:printing/printing.dart';

class PrinterInfo {
  final Printer printer;
  String status;
  int jobCount;

  PrinterInfo({
    required this.printer,
    this.status = 'Unknown',
    this.jobCount = 0,
  });
}
