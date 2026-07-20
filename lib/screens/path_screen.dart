import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:my_printer_app/core/test_code.dart';
import 'package:my_printer_app/screens/home_screen.dart';
import 'package:my_printer_app/screens/splash_screen.dart';
import 'package:my_printer_app/services/free_trial_protection_or_active.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select path'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await LicenseHelper.deactivateLicense();
              Get.offAll(() => SplashScreen());
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                pickFolder();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('حدد مكان الملفات'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'هذا البرنامج صنع بواسطة @Axon_plus   Instagram: @i_zoz_24',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> pickFolder() async {
  String? selectedDirectory;
  if (isTesting) {
    selectedDirectory = '/Users/axon/Desktop/';
  } else {
    // افتح نافذة اختيار المجلد
    selectedDirectory = await FilePicker.platform.getDirectoryPath();
  }

  if (selectedDirectory != null) {
    final controller = Get.find<Controler>();
    controller.isSavedPath.value = selectedDirectory;
    controller.saveStringToCache(selectedDirectory);
    print('selectedDirectory: $selectedDirectory');
    Get.offAll(() => HomeScreen());
    Get.snackbar(
      '📁 تم حفظ المجلد',
      'تم حفظ مسار المجلد بنجاح',
      snackPosition: SnackPosition.BOTTOM,
    );
  } else {
    Get.snackbar(
      '❌ خطأ',
      'لم يتم تحديد أي مجلد',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
