import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_printer_app/services/statistics_service.dart';
import 'package:my_printer_app/model/print_statistics.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:my_printer_app/screens/password_screen.dart';
import 'package:my_printer_app/screens/home_screen.dart';

class StatisticsScreen extends StatelessWidget {
  final _statisticsService = StatisticsService.instance;
  final _currencyFormat = NumberFormat.currency(symbol: 'EGP ');

  StatisticsScreen({super.key});

  Future<void> _resetStatistics() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Reset Statistics'),
        content: Text(
          'Are you sure you want to reset all statistics? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Reset'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Show password screen for verification
      final passwordResult = await Get.to<bool>(() => PasswordScreen());
      if (passwordResult == true) {
        await _statisticsService.resetStatistics();
        Get.snackbar(
          'Success',
          'Statistics have been reset',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => HomeScreen()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              Get.to(() => PasswordScreen());
            },
          ),
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetStatistics),
        ],
      ),
      body: Obx(() {
        final stats = _statisticsService.statistics;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceConfigCard(context),
              SizedBox(height: 16),
              _buildStatCard(
                'Total Files Printed',
                stats.totalFiles.toString(),
                Icons.description,
              ),
              _buildStatCard(
                'Total Orders',
                stats.totalOrders.toString(),
                Icons.shopping_cart,
              ),
              _buildStatCard(
                'Total Pages',
                stats.totalPages.toString(),
                Icons.pages,
              ),
              _buildStatCard(
                'Most Printed File',
                stats.mostPrintedFile,
                Icons.star,
              ),
              _buildStatCard(
                'Total Earnings',
                _currencyFormat.format(stats.totalEarnings),
                Icons.attach_money,
              ),
              SizedBox(height: 20),
              Text(
                'Recent Print History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              ...stats.printHistory.reversed
                  .take(10)
                  .map((record) => _buildHistoryItem(record)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPriceConfigCard(BuildContext context) {
    final controller = TextEditingController(
      text: _statisticsService.pricePerPage.toString(),
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price per page (EGP)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final newPrice = double.tryParse(controller.text) ?? 0.5;
                    _statisticsService.updatePricePerPage(newPrice);
                    Get.snackbar(
                      'Success',
                      'Price updated to ${_currencyFormat.format(newPrice)} per page',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(PrintRecord record) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.print),
        title: Text(record.fileName),
        subtitle: Text('${record.pages} pages × ${record.copies} copies'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _currencyFormat.format(record.earnings),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              DateFormat('MMM d, y').format(record.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
