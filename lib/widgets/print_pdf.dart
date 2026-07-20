import 'dart:io';
import 'package:get/get.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:printing/printing.dart';

Future<bool> printPdf({
  required Printer printer,
  required bool isDuplex,
  required String pdfPath,
  required int copies,
}) async {
  Get.find<Controler>();
  // تحديد المسار لملف SumatraPDF.exe
  final sumatraPath = getSumatraPath();

  // جهز الـ arguments حسب المطلوب
  List<String> args = [
    '-silent', // تشغيل بدون واجهة
    '-print-to', printer.name, // تحديد الطابعة
  ];

  // إعدادات الطباعة
  String printSettings = 'fit'; // نبدأ بـ fit كإعداد أساسي

  if (isDuplex) {
    printSettings = 'duplex,$printSettings'; // نضيف duplex
  }

  if (copies > 1) {
    printSettings =
        'copies=$copies,$printSettings'; // نضيف عدد النسخ
  }

  // إضافة الإعدادات إذا فيه إعدادات
  args.addAll(['-print-settings', printSettings]);

  // أخيرًا نضيف مسار الملف
  args.add(pdfPath);

  // تحقق إذا كان ملف SumatraPDF.exe موجود
  if (!File(sumatraPath).existsSync()) {
    Get.snackbar(
      'Error',
      'لم يتم العثور على SumatraPDF.exe في مجلد التطبيق.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  try {
    final result = await Process.run(sumatraPath, args);

    if (result.exitCode != 0) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'فشل في طباعة الملف: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }
}

// هذه الدالة تقوم بإرجاع المسار الكامل لملف SumatraPDF.exe
String getSumatraPath() {
  final appDirectory = Directory.current.path;
  final sumatraPath = '$appDirectory\\SumatraPDF.exe';
  return sumatraPath;
}
