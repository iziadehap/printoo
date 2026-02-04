import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

List<String> getPdfFileNames(String folderPath) {
  try {
    final dir = Directory(folderPath);
    final pdfFiles =
        dir
            .listSync()
            .where((file) => file is File && file.path.endsWith('.pdf'))
            .map((file) => basename(file.path)) // دي بتجيب اسم الملف بس
            .toList()
            .cast<String>();

    return pdfFiles;
  } catch (e) {
    print('Error in getPdfFileNames: $e');
    Get.snackbar(
      'Error',
      'لا توجد ملفات في هذا المجلد',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return [];
  }
}
