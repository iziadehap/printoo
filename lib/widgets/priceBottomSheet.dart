import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_printer_app/controller/controler.dart';

class PriceBottomSheet extends StatelessWidget {
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'السعر الحالي للصفحة الواحدة: ${Get.find<Controler>().pricePerPage.value.toStringAsFixed(2)} \$',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "💵 تعديل السعر للصفحة الواحدة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Price (EG: 0.5)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save"),
              onPressed: () async {
                double? newPrice = double.tryParse(priceController.text);
                if (newPrice != null) {
                  Get.find<Controler>().pricePerPage.value = newPrice;

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setDouble('pricePerPage', newPrice);

                  Get.back(); // Close BottomSheet
                  Get.snackbar(
                    "تم الحفظ ✅",
                    "تم تحديث السعر إلى ${newPrice.toStringAsFixed(2)} \$",
                  );
                } else {
                  Get.snackbar("❌ خطأ", "اكتب رقم سعر صحيح");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
