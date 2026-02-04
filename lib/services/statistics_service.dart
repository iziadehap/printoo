import 'dart:convert';
import 'package:get/get.dart';
import 'package:my_printer_app/model/print_statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsService extends GetxService {
  static StatisticsService? _instance;
  final _statistics = PrintStatistics().obs;
  final _pricePerPage = 0.5.obs;

  static StatisticsService get instance {
    _instance ??= StatisticsService();
    return _instance!;
  }

  PrintStatistics get statistics => _statistics.value;
  double get pricePerPage => _pricePerPage.value;

  Future<void> initialize() async {
    await _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load price per page
      _pricePerPage.value = prefs.getDouble('pricePerPage') ?? 0.5;

      // Load statistics
      final statsJson = prefs.getString('statistics');
      if (statsJson != null) {
        final Map<String, dynamic> statsMap = json.decode(statsJson);
        _statistics.value = PrintStatistics.fromJson(statsMap);
      }
    } catch (e) {
      print('Error loading statistics from cache: $e');
    }
  }

  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save price per page
      await prefs.setDouble('pricePerPage', _pricePerPage.value);

      // Save statistics
      final statsJson = json.encode(_statistics.value.toJson());
      await prefs.setString('statistics', statsJson);
    } catch (e) {
      print('Error saving statistics to cache: $e');
    }
  }

  Future<void> recordPrint(String fileName, int pages, int copies) async {
    final earnings = pages * copies * _pricePerPage.value;
    final record = PrintRecord(
      fileName: fileName,
      pages: pages,
      copies: copies,
      earnings: earnings,
      timestamp: DateTime.now(),
    );

    _statistics.update((val) {
      if (val != null) {
        val.totalFiles++;
        val.totalOrders += copies;
        val.totalPages += pages * copies;
        val.totalEarnings += earnings;
        val.printHistory.add(record);

        // Update most printed file based on path components
        final pathParts = fileName.split('/');
        if (pathParts.length >= 3) {
          val.mostPrintedFile =
              '${pathParts[pathParts.length - 3]} - ${pathParts[pathParts.length - 2]} - ${pathParts[pathParts.length - 1]}';
        }
      }
    });

    await _saveToCache();
  }

  Future<void> updatePricePerPage(double newPrice) async {
    _pricePerPage.value = newPrice;
    await _saveToCache();
  }

  Future<void> resetStatistics() async {
    _statistics.value = PrintStatistics();
    await _saveToCache();
  }
}
