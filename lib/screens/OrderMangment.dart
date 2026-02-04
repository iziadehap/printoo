import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:my_printer_app/model/printOrderModel.dart';

class ManageOrdersScreen extends StatelessWidget {
  final controller = Get.find<Controler>();

   ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🖨️ إدارة الطلبات'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.printList.isEmpty) {
          return const Center(
            child: Text(
              '🚫 لا توجد طلبات حالياً',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.printList.length,
          itemBuilder: (context, index) {
            PrintOrderModel order = controller.printList[index];
            return PrintOrderWidget(
              order: order,
              index: index,
              onPrint: () {
                controller.addFile_and_print(true, true, order);
                Get.defaultDialog(
                  title: '📄 إعادة طباعة',
                  content: const Text(
                    'تمت إضافة الملف إلى قائمة الطباعة',
                    style: TextStyle(fontSize: 16),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text('حسناً'),
                  ),
                );
              },
              onDelete: () {
                try {
                  int actualIndex = index + controller.printedCount.value;

                  if (actualIndex >= controller.printList.length ||
                      actualIndex < 0) {
                    throw Exception("Invalid index");
                  }

                  final removedOrder = controller.printList.removeAt(
                    actualIndex,
                  );
                  controller.pageCountList.removeWhere(
                    (count) => count == removedOrder.pageCount,
                  );

                  controller.printList.refresh();
                  controller.pageCountList.refresh();

                  Get.defaultDialog(
                    title: '🗑️ تم الحذف',
                    content: const Text('تم حذف الطلب من القائمة بنجاح'),
                    confirm: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('موافق'),
                    ),
                  );
                } catch (e) {
                  Get.defaultDialog(
                    title: '⚠️ خطأ',
                    content: const Text('حدث خطأ أثناء محاولة حذف الطلب.'),
                    confirm: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('حسناً'),
                    ),
                  );
                }
              },
            );
          },
        );
      }),
    );
  }
}

class PrintOrderWidget extends StatelessWidget {
  final PrintOrderModel order;
  final int index;
  final VoidCallback onPrint;
  final VoidCallback onDelete;

  const PrintOrderWidget({
    super.key,
    required this.order,
    required this.index,
    required this.onPrint,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// اسم الملف
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order.path.split('/').last.replaceAll('.pdf', ''),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// تفاصيل الطلب
          Text('🖨️ الطابعة: ${order.printerName}'),
          Text('📄 الصفحات: ${order.pageCount}'),
          Text('📑 النسخ: ${order.copies}'),
          Text(
            '📁 الملف: ${order.path}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              /// زر الطباعة
              ElevatedButton.icon(
                onPressed: onPrint,
                icon: const Icon(Icons.print, color: Colors.white),
                label: const Text('إعادة الطباعة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const Spacer(),

              /// زر الحذف
              ElevatedButton.icon(
                onPressed: () {
                  if (controller.isPrinting.value && index == 0) {
                    Get.defaultDialog(
                      title: '🚫 لا يمكن الحذف',
                      content: const Text(
                        'الطلب الأول يتم طباعته الآن ولا يمكن حذفه.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      confirm: ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('موافق'),
                      ),
                    );
                  } else {
                    onDelete();
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('حذف الطلب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
