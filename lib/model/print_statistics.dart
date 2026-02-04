
class PrintStatistics {
  int totalFiles;
  int totalOrders;
  int totalPages;
  double totalEarnings;
  String mostPrintedFile;
  List<PrintRecord> printHistory;

  PrintStatistics({
    this.totalFiles = 0,
    this.totalOrders = 0,
    this.totalPages = 0,
    this.totalEarnings = 0.0,
    this.mostPrintedFile = 'None',
    List<PrintRecord>? printHistory,
  }) : printHistory = printHistory ?? [];

  void addRecord(PrintRecord record) {
    totalFiles++;
    totalOrders++;
    totalPages += record.pages * record.copies;
    totalEarnings += record.earnings;
    printHistory.add(record);

    // Update most printed file
    Map<String, int> fileCounts = {};
    for (var record in printHistory) {
      fileCounts[record.fileName] =
          (fileCounts[record.fileName] ?? 0) + record.copies;
    }
    if (fileCounts.isNotEmpty) {
      mostPrintedFile =
          fileCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFiles': totalFiles,
      'totalOrders': totalOrders,
      'totalPages': totalPages,
      'totalEarnings': totalEarnings,
      'mostPrintedFile': mostPrintedFile,
      'printHistory': printHistory.map((record) => record.toJson()).toList(),
    };
  }

  factory PrintStatistics.fromJson(Map<String, dynamic> json) {
    return PrintStatistics(
      totalFiles: json['totalFiles'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalEarnings: json['totalEarnings']?.toDouble() ?? 0.0,
      mostPrintedFile: json['mostPrintedFile'] ?? 'None',
      printHistory:
          (json['printHistory'] as List?)
              ?.map((record) => PrintRecord.fromJson(record))
              .toList() ??
          [],
    );
  }
}

class PrintRecord {
  final String fileName;
  final int pages;
  final int copies;
  final double earnings;
  final DateTime timestamp;

  PrintRecord({
    required this.fileName,
    required this.pages,
    required this.copies,
    required this.earnings,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'pages': pages,
      'copies': copies,
      'earnings': earnings,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PrintRecord.fromJson(Map<String, dynamic> json) {
    return PrintRecord(
      fileName: json['fileName'],
      pages: json['pages'],
      copies: json['copies'],
      earnings: json['earnings'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
