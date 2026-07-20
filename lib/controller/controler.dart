import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:my_printer_app/model/printerInfo.dart';
import 'package:my_printer_app/services/free_trial_protection_or_active.dart';
import 'package:my_printer_app/widgets/getPageCount.dart';
import 'package:my_printer_app/model/page_Counter_model.dart';
import 'package:my_printer_app/widgets/pdf_in_file.dart';
import 'package:my_printer_app/model/printOrderModel.dart';
import 'package:my_printer_app/widgets/print_pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_printer_app/services/statistics_service.dart';

class Controler extends GetxController {
  // 👇 Add this flag at the top of the class
  bool isTesting = true; // Set to false for production

  // printer var
  var printers = <PrinterInfo>[].obs;
  var selectedPrinter = Rx<PrinterInfo?>(null);
  RxDouble pricePerPage = 0.5.obs;
  //
  //
  //
  //

  // pdf var
  Rxn<String> isSavedPath = Rxn<String>();
  var pageCount = 0.obs;
  var isDuplex = true.obs;
  var isLoading = true.obs;
  RxList<PrintStats> pageCountList = <PrintStats>[].obs;
  RxList<PrintOrderModel> printList = <PrintOrderModel>[].obs;
  var isPrinting = false.obs;
  var showCheck = false.obs;
  var lastPageCount = 0.obs;
  var printedCount = 0.obs;
  var copies = 1.obs;
  RxBool saveCopies = false.obs;
  var isAllSelected = false.obs;
  //
  //
  //
  //
  //
  //
  //

  // path var
  var mainPath = 'المتميز'.obs;
  var sacandPath = '3ب'.obs;
  var thirdPath = 'اسئله'.obs;
  var fourthPath = ''.obs;
  RxList<Map<String, dynamic>> pdfFiles = <Map<String, dynamic>>[].obs;
  RxInt activationStatus = 0.obs;
  RxBool isCheckedFreeTrial = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadPrinters();
    loadPathFromCache();
    loadPricePerPage();
  }

  Future<void> checkFreeTrialStatus() async {
    activationStatus.value = await LicenseHelper.checkFreeTrialStatus();
    isCheckedFreeTrial.value = true;
    print(activationStatus.value);
    print('-----------------------');
    print('-----------------------');
    print('-----------------------');
    print('-----------------------');
    print('-----------------------');
  }

  // ignore: non_constant_identifier_names
  Future<void> addFile_and_print(
    bool add,
    bool custom,
    PrintOrderModel? customModel,
  ) async {
    if (add && !custom) {
      var filePath =
          '${isSavedPath.value}/$mainPath/$sacandPath/$thirdPath/$fourthPath.pdf';
      printList.add(
        PrintOrderModel(
          path: filePath,
          printerName: selectedPrinter.value!.printer.name,
          isDuplex: isDuplex.value,
          copies: copies.value,
          pageCount: pageCount.value,
        ),
      );

      pageCountList.add(
        PrintStats(pages: pageCount.value, copies: copies.value),
      );
    }
    if (add && custom) {
      printList.add(
        PrintOrderModel(
          path: customModel!.path,
          printerName: customModel.printerName,
          isDuplex: customModel.isDuplex,
          copies: customModel.copies,
          pageCount: customModel.pageCount,
        ),
      );
    }

    if (isPrinting.value) return;

    isPrinting.value = true;

    while (printList.isNotEmpty) {
      var order = printList.first;

      for (int i = 0; i < order.copies; i++) {
        bool success;
        
        if (isTesting) {
          // Fake print for testing
          print('🖨️ [TEST] Printing: ${order.path}');
          print('📄 Page count: ${order.pageCount}');
          print('📋 Copies: ${order.copies}');
          print('🔄 Duplex: ${order.isDuplex}');
          print('🖨️ Printer: ${order.printerName}');
          success = true; // Simulate success
          await Future.delayed(Duration(seconds: 1)); // Simulate printing delay
        } else {
          // Real print
          success = await printPdf(
            copies: order.copies,
            pdfPath: order.path,
            printer: selectedPrinter.value!.printer,
            isDuplex: order.isDuplex,
          );
        }

        if (!success) {
          break;
        }
      }

      printList.removeAt(0);
      printedCount.value++;

      // After successful printing, add statistics
      if (!isTesting) {
        await StatisticsService.instance.recordPrint(
          order.path,
          order.pageCount,
          order.copies,
        );
      }
    }

    isPrinting.value = false;
  }


  void ifAllSelected() {
    bool allSelected;

    if (selectedPrinter.value == null) {
      allSelected = false;
    } else {
      allSelected = true;
    }

    bool isFourthPathSelected;

    if (fourthPath.value == '') {
      isFourthPathSelected = false;
    } else {
      isFourthPathSelected = true;
    }

    if (allSelected && isFourthPathSelected) {
      isAllSelected.value = true;
    } else {
      isAllSelected.value = false;
    }
  }

  double calculateEarnings(int pages, int copies) {
    final pricePerPage = StatisticsService.instance.pricePerPage;
    return pages * copies * pricePerPage;
  }

  int getTotalPage() {
    // String expression = pageCountList.map((e) => e.toString()).join(' + ');
    int total = pageCountList.fold(0, (sum, e) => sum + e.totalPages);
    return total;
  }

  String get pageCounterSummary {
    final expression = pageCountList.map((e) => e.toString()).join(' + ');
    final total = pageCountList.fold(0, (sum, e) => sum + e.totalPages);
    return '$expression = $total صفحة';
  }

  void getPageCount_controller() {
    getPageCount(
      '${isSavedPath.value}/$mainPath/$sacandPath/$thirdPath/$fourthPath.pdf',
    ).then((value) {
      if (value == 0) {
        pageCount.value = 0;
        fourthPath.value = '';
        isAllSelected.value = false;
      } else {
        pageCount.value = value;
      }
    });
  }

  void getFiles() async {
    final folderPath = '${isSavedPath.value}/$mainPath/$sacandPath/$thirdPath';

    if (isTesting) {
      // 👇 Fake files for testing
      pdfFiles.assignAll([
        {'name': 'اختبار 1', 'pages': 5},
        {'name': 'اختبار 2', 'pages': 3},
        {'name': 'اختبار 3', 'pages': 7},
        {'name': 'مستند تجريبي', 'pages': 10},
      ]);
      print('🧪 [TEST] Using fake PDF files');
      return;
    }

    // Real implementation
    final fileNames = getPdfFileNames(folderPath);

    List<Map<String, dynamic>> filesWithPageCount = [];

    for (var name in fileNames) {
      final filePath = '$folderPath/$name';
      final pageCount = await getPageCount(filePath);

      filesWithPageCount.add({
        'name': name.replaceAll('.pdf', ''),
        'pages': pageCount,
      });
    }

    pdfFiles.assignAll(filesWithPageCount);
  }

  Future<bool> loadPathFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('files_path');
    isSavedPath.value = value;
    if (isSavedPath.value != null) {
      getFiles();
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveStringToCache(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('files_path', value);
  }

  Future<void> deletePathFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('files_path'); // 🧹 يحذف القيمة من الكاش
    isSavedPath.value = null; // أو أي قيمة مبدئية مناسبة
  }

  Future<void> loadPricePerPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pricePerPage.value = prefs.getDouble('pricePerPage') ?? 0.5;
  }

  Timer? _printerStatusTimer;

  @override
  void onClose() {
    _printerStatusTimer?.cancel(); // ❌ يوقف التحديث الدوري
    super.onClose();
  }

  Future<void> loadPrinters() async {
    try {
      isLoading.value = true;

      if (isTesting) {
        // 👇 Fake printers for testing
        final fakePrinters = [
          PrinterInfo(
            printer: Printer(name: 'اختبار - طابعة 1', isDefault: true, url: ''),
            status: 'Ready',
            jobCount: 0,
          ),
          PrinterInfo(
            printer: Printer(name: 'اختبار - طابعة 2', isDefault: false, url: ''),
            status: 'Printing',
            jobCount: 2,
          ),
          PrinterInfo(
            printer: Printer(name: 'اختبار - طابعة 3', isDefault: false, url: ''),
            status: 'Paused',
            jobCount: 1,
          ),
        ];
        printers.assignAll(fakePrinters);
        isLoading.value = false;
        print('🧪 [TEST] Using fake printers');
        return;
      }

      // Real implementation
      List<Printer> result = await Printing.listPrinters();

      printers.assignAll(
        result.map((printer) => PrinterInfo(printer: printer)).toList(),
      );

      await updatePrintersStatus(); // تحديث أولي

      startPrinterStatusUpdates(); // ✅ يبدأ التحديث الدوري
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error loading printers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void startPrinterStatusUpdates() {
    if (isTesting) {
      print('🧪 [TEST] Skipping printer status updates');
      return;
    }
    
    _printerStatusTimer?.cancel();
    _printerStatusTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      await updatePrintersStatus();
    });
  }

  Future<void> updatePrintersStatus() async {
    if (isTesting) {
      // Keep fake statuses for testing
      return;
    }

    final updatedList = <PrinterInfo>[];

    for (final p in printers) {
      try {
        final result = await Process.run('powershell', [
          '-Command',
          '''
try {
  \$printer = Get-Printer -Name "${p.printer.name}" -ErrorAction Stop
  \$jobs = @(Get-PrintJob -PrinterName "${p.printer.name}")
  [PSCustomObject]@{
    Status = \$printer.PrinterStatus
    JobCount = \$jobs.Count
    WorkOffline = \$printer.WorkOffline
    PrinterState = \$printer.PrinterState
    ExtendedPrinterStatus = \$printer.ExtendedPrinterStatus
  } | ConvertTo-Json -Compress
} catch {
  [PSCustomObject]@{
    Status = -1
    JobCount = 0
    WorkOffline = \$true
    PrinterState = -1
    ExtendedPrinterStatus = -1
  } | ConvertTo-Json -Compress
}
''',
        ]);

        if (result.exitCode == 0) {
          final json = jsonDecode(result.stdout);
          final int status = json['Status'] ?? -1;
          final int printerState = json['PrinterState'] ?? -1;
          final int extendedStatus = json['ExtendedPrinterStatus'] ?? -1;
          final bool isOffline = json['WorkOffline'] ?? false;
          final int jobCount = json['JobCount'] ?? 0;

          // تحقق متقدم
          String finalStatus;

          if (isOffline ||
              status == 7 ||
              printerState == 0 ||
              extendedStatus == 0) {
            finalStatus = "مفصولة (Disconnected)";
          } else {
            finalStatus = translatePrinterStatus(status);
          }

          updatedList.add(
            PrinterInfo(
              printer: p.printer,
              status: finalStatus,
              jobCount: jobCount,
            ),
          );
        } else {
          updatedList.add(
            PrinterInfo(printer: p.printer, status: 'خطأ (Error)', jobCount: 0),
          );
        }
      } catch (_) {
        updatedList.add(
          PrinterInfo(
            printer: p.printer,
            status: 'مفصولة (Disconnected)',
            jobCount: 0,
          ),
        );
      }
    }

    printers.assignAll(updatedList);
  }

  String translatePrinterStatus(int status) {
    switch (status) {
      case 0:
        return "Ready";
      case 1:
        return "Paused";
      case 2:
        return "Error";
      case 3:
        return "Printing";
      case 4:
        return "Paper Jam";
      case 5:
        return "Paper Out";
      case 7:
        return "Offline";
      default:
        return "Unknown ($status)";
    }
  }

  void selectPrinter(PrinterInfo printer) {
    selectedPrinter.value = printer;
    // ignore: avoid_print
    print("🖨️ Selected printer: ${selectedPrinter.value?.printer.name}");
  }
}