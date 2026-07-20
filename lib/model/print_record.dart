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
    required this.timestamp,
  });

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
      fileName: json['fileName'] ?? '',
      pages: json['pages'] ?? 0,
      copies: json['copies'] ?? 0,
      earnings: json['earnings']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
