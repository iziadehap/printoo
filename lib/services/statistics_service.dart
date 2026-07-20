import 'dart:convert';
import 'package:get/get.dart';
import 'package:my_printer_app/model/print_statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsService extends GetxService {
  static StatisticsService? _instance;
  final _statistics = PrintStatistics().obs;
  final _pricePerPage = 0.5.obs;
  
  // 👇 Add this flag - you can sync it with the Controller's isTesting
  bool isTesting = true; // Set to false for production

  static StatisticsService get instance {
    _instance ??= StatisticsService();
    return _instance!;
  }

  PrintStatistics get statistics => _statistics.value;
  double get pricePerPage => _pricePerPage.value;

  Future<void> initialize() async {
    if (isTesting) {
      // Load fake data for testing
      await _loadFakeData();
    } else {
      await _loadFromCache();
    }
  }

  // 👇 New method for fake data
  Future<void> _loadFakeData() async {
    print('🧪 [TEST] Loading fake statistics data');
    
    // Create fake statistics
    final fakeStats = PrintStatistics(
      totalFiles: 42,
      totalOrders: 15,
      totalPages: 328,
      totalEarnings: 164.0,
      mostPrintedFile: 'المتميز - 3ب - اسئله',
      printHistory: [
        PrintRecord(
          fileName: '/Users/axon/Desktop/المتميز/3ب/اسئله/اختبار 1.pdf',
          pages: 5,
          copies: 2,
          earnings: 5.0,
          timestamp: DateTime.now().subtract(Duration(days: 1)),
        ),
        PrintRecord(
          fileName: '/Users/axon/Desktop/المتميز/3ب/اسئله/اختبار 2.pdf',
          pages: 3,
          copies: 1,
          earnings: 1.5,
          timestamp: DateTime.now().subtract(Duration(hours: 5)),
        ),
        PrintRecord(
          fileName: '/Users/axon/Desktop/المتميز/3ب/اسئله/مستند تجريبي.pdf',
          pages: 10,
          copies: 3,
          earnings: 15.0,
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        ),
        PrintRecord(
          fileName: '/Users/axon/Desktop/المتميز/3ب/اسئله/اختبار 3.pdf',
          pages: 7,
          copies: 2,
          earnings: 7.0,
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        ),
      ],
    );
    
    _statistics.value = fakeStats;
    _pricePerPage.value = 0.5;
    
    print('🧪 [TEST] Fake statistics loaded:');
    print('   📊 Total Files: ${fakeStats.totalFiles}');
    print('   📋 Total Orders: ${fakeStats.totalOrders}');
    print('   📄 Total Pages: ${fakeStats.totalPages}');
    print('   💰 Total Earnings: \$${fakeStats.totalEarnings}');
    print('   🏆 Most Printed: ${fakeStats.mostPrintedFile}');
    print('   📝 History Entries: ${fakeStats.printHistory.length}');
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
    if (isTesting) {
      print('🧪 [TEST] Skipping cache save (testing mode)');
      return;
    }
    
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
    if (isTesting) {
      // Fake record for testing
      print('🧪 [TEST] Recording fake print:');
      print('   📄 File: $fileName');
      print('   📋 Pages: $pages');
      print('   📋 Copies: $copies');
      
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
      
      print('🧪 [TEST] Fake record added successfully');
      return;
    }

    // Real implementation
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
    if (isTesting) {
      print('🧪 [TEST] Updating fake price per page: $newPrice');
      _pricePerPage.value = newPrice;
      return;
    }
    
    _pricePerPage.value = newPrice;
    await _saveToCache();
  }

  Future<void> resetStatistics() async {
    if (isTesting) {
      print('🧪 [TEST] Resetting fake statistics');
      _statistics.value = PrintStatistics();
      return;
    }
    
    _statistics.value = PrintStatistics();
    await _saveToCache();
  }
  
  // 👇 Optional: Helper method to add more fake data
  void addFakePrintRecord(String fileName, int pages, int copies) {
    if (isTesting) {
      recordPrint(fileName, pages, copies);
    }
  }
}