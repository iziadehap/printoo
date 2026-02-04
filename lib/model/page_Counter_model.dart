// ignore: file_names
class PrintStats {
  final int pages;
  final int copies;

  PrintStats({
    required this.pages,
    required this.copies,
  });

  int get totalPages => pages * copies;

  @override
  String toString() {
    if (copies == 1) {
      return '$pages';
    } else {
      return '($pages×$copies)';
    }
  }
}
