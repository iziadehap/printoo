class PrintOrderModel {
  final String path;
  final String printerName;
  final bool isDuplex;
  final int copies;
  final int pageCount;

  PrintOrderModel({
    required this.path,
    required this.printerName,
    required this.isDuplex,
    required this.copies,
    required this.pageCount,
  });
}
