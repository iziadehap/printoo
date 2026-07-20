import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:my_printer_app/model/page_Counter_model.dart';
import 'package:my_printer_app/model/printerInfo.dart';
import 'package:my_printer_app/screens/path_screen.dart';
import 'package:my_printer_app/screens/OrderMangment.dart';
import 'package:my_printer_app/widgets/priceBottomSheet.dart';
import 'package:win32/win32.dart';
import 'package:my_printer_app/screens/password_screen.dart';
import 'package:my_printer_app/widgets/animated_gradient_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<Controler>();
    controller.checkFreeTrialStatus();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();
    return Scaffold(
      // appBar: AppBar(
      //   leading:
      //       controller.activationStatus.value == 999
      //           ? IconButton(
      //             icon: Icon(Icons.attach_money_rounded, color: Colors.green),
      //             onPressed: () {
      //               Get.bottomSheet(
      //                 PriceBottomSheet(),
      //                 isScrollControlled: true,
      //                 backgroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.vertical(
      //                     top: Radius.circular(20),
      //                   ),
      //                 ),
      //               );
      //             },
      //           )
      //           : Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               IconButton(
      //                 icon: Icon(
      //                   Icons.attach_money_rounded,
      //                   color: Colors.green,
      //                 ),
      //                 onPressed: () {
      //                   Get.bottomSheet(
      //                     PriceBottomSheet(),
      //                     isScrollControlled: true,
      //                     backgroundColor: Colors.white,
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.vertical(
      //                         top: Radius.circular(20),
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               ),
      //               Container(
      //                 height: 30,
      //                 margin: EdgeInsets.only(right: 8),
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: 12,
      //                   vertical: 4,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(15),
      //                   gradient: LinearGradient(
      //                     begin: Alignment.centerLeft,
      //                     end: Alignment.centerRight,
      //                     colors: [
      //                       Colors.blue,
      //                       Colors.purple,
      //                       Colors.orange,
      //                       Colors.green,
      //                     ],
      //                     stops: [0.0, 0.33, 0.66, 1.0],
      //                   ),
      //                 ),
      //                 child: Center(
      //                   child: Text(
      //                     'لديك 3 يوم تجريبي',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 12,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Get.off(() => PasswordScreen());
      //       },
      //       icon: Icon(Icons.bar_chart),
      //     ),
      //     IconButton(
      //       onPressed: () {
      //         Get.offAll(PathScreen());
      //         controller.deletePathFromCache();
      //       },
      //       icon: Icon(Icons.delete),
      //     ),
      //   ],
      //   title: const Text('Made with ❤️ by @Axon_plus'),
      // ),
      body: Column(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            color: Colors.black,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_money_rounded, color: Colors.green),
                  onPressed: () {
                    Get.bottomSheet(
                      PriceBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
                Obx(() {
                  if (controller.isCheckedFreeTrial.value) {
                    return controller.activationStatus.value != 999
                        ? AnimatedGradientContainer(
                          text:
                              'لديك ${controller.activationStatus.value} يوم تجريبي',
                        )
                        : Container();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
                Expanded(
                  child: Center(
                    child: Text(
                      'Made with ❤️ by @Axon_plus',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.off(() => PasswordScreen());
                  },
                  icon: Icon(Icons.bar_chart, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Get.offAll(PathScreen());
                    controller.deletePathFromCache();
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.printers.isEmpty && !controller.isLoading.value
                  ? const Center(
                    child: Text('No printers found, please check your printer'),
                  )
                  : Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color:
                              controller.thirdPath.value == 'اسئله'
                                  ? Color(0xFF1f313b)
                                  : Color(0xff060D12),
                          height: double.infinity,
                          child: Obx(() {
                            return Column(
                              children: [
                                Highlite('Options'),
                                InkWell(
                                  onTap:
                                      controller.showCheck.value
                                          ? null // ⛔ ممنوع الضغط إذا العلامة ✅ ظاهرة (أو اللودينج شغّال)
                                          : () async {
                                            if (controller
                                                .isAllSelected
                                                .value) {
                                              // ✅ تشغيل صوت النظام
                                              PlaySound(
                                                TEXT('SystemAsterisk'),
                                                NULL,
                                                SND_ALIAS | SND_ASYNC,
                                              );

                                              // ✅ أظهر لودينج بدل علامة الصح
                                              controller.showCheck.value = true;

                                              controller.addFile_and_print(
                                                true,
                                                false,
                                                null,
                                              );

                                              await Future.delayed(
                                                Duration(seconds: 2),
                                              );
                                              if (controller.saveCopies.value ==
                                                  false) {
                                                controller.copies.value = 1;
                                              }

                                              controller.showCheck.value =
                                                  false;
                                            }
                                          },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.isAllSelected.value
                                              ? Colors.blue
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 100,
                                    width: 300,
                                    child: Center(
                                      child:
                                          controller.showCheck.value
                                              ? CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                                strokeWidth: 4,
                                              ) // 🔄 بدل الأيقونة ✅
                                              : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Print',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${controller.pageCount.value}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          '|',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${(controller.pageCount.value * controller.pricePerPage.value).toStringAsFixed(0)} \$',
                                                          style: TextStyle(
                                                            color:
                                                                const Color.fromARGB(
                                                                  255,
                                                                  1,
                                                                  248,
                                                                  9,
                                                                ),
                                                            fontSize: 22,
                                                            shadows: [
                                                              Shadow(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                blurRadius: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          controller.isDuplex.value
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color:
                                              controller.isDuplex.value
                                                  ? Colors.green
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          controller.isDuplex.value =
                                              !controller.isDuplex.value;
                                        },
                                      ),

                                      Text(
                                        '2 side (duplex)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          // fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    // vertical: 15,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      IconButton(
                                        onPressed:
                                            controller.copies.value > 1
                                                ? () =>
                                                    controller.copies.value--
                                                : null,
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Text(
                                        '${controller.copies.value}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => controller.copies.value++,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          controller.saveCopies.value
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color:
                                              controller.saveCopies.value
                                                  ? Colors.green
                                                  : Colors.grey,
                                        ),
                                        onPressed: () {
                                          controller.saveCopies.value =
                                              !controller.saveCopies.value;
                                        },
                                      ),

                                      Text(
                                        'Save Copies',
                                        style: TextStyle(
                                          color: Colors.white,
                                          // fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ManageOrdersScreen());
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'مهام ${controller.printList.length}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color:
                              controller.thirdPath.value == 'اسئله'
                                  ? Color(0xff383852)
                                  : Color(0xff0A1622),
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Highlite('Printers'),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var printerInfo in controller.printers)
                                      PrinterListBuilder(
                                        printerInfo: printerInfo,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Obx(() {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            color:
                                controller.thirdPath.value == 'اسئله'
                                    ? const Color(0xff784259)
                                    : const Color(0xff0D1B2A),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(child: Highlite('صفحات')),
                                    Container(
                                      width: 80,
                                      height: 50,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    Expanded(child: Highlite('سعر')),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.pdfFiles.length,
                                    itemBuilder: (context, index) {
                                      return FourthBox(
                                        text: controller.pdfFiles[index],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      Expanded(
                        flex: 4,

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color:
                              controller.thirdPath.value == 'اسئله'
                                  ? Color(0xffb94e56)
                                  : Color(0xff263B50),
                          child: Column(
                            children: [
                              Highlite('الاسئله'),
                              ThirdBox(text: 'اسئله'),
                              ThirdBox(text: 'اجابه'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color:
                              controller.thirdPath.value == 'اسئله'
                                  ? Color(0xffbe4039)
                                  : Color(0xff40566E),
                          child: Column(
                            children: [
                              Highlite('الصفوف'),
                              SecondBox(text: '3ب'),
                              SecondBox(text: '4ب'),
                              SecondBox(text: '5ب'),
                              SecondBox(text: '6ب'),
                              SecondBox(text: '1ع'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          color:
                              controller.thirdPath.value == 'اسئله'
                                  ? Color(0xff683566)
                                  : Color(0xff5A738E),
                          child: Column(
                            children: [
                              Highlite('المذكرات'),
                              MainBox(text: 'المتميز'),
                              MainBox(text: 'المتفوق'),
                              MainBox(text: 'التاسيس السليم'),
                              Spacer(),
                              Text(
                                '${controller.lastPageCount.value} الصفحات الاخيرة',
                              ),
                              controller.pageCountList.isNotEmpty
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        // margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                          //   vertical: 10,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            controller.printedCount.value = 0;
                                            controller
                                                .lastPageCount
                                                .value = controller
                                                .pageCountList
                                                .fold<int>(
                                                  0,
                                                  (sum, count) =>
                                                      sum + count.totalPages,
                                                );

                                            controller.pageCountList.clear();
                                            controller.getTotalPage();
                                          },
                                          icon: Icon(Icons.restart_alt),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),

                                          // color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Text(
                                          controller.getTotalPage().toString(),
                                          // '2+2+5+4+5+4+4+5+4+7+7+5+5+542+45+5424+5+458+78+78+7+5+4753+75+752+753+78+5+78+753+75+7+78=5000',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Container(
                                    // width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: Colors.white,
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'لا يوجد صفحات مطبوعة',
                                      style: TextStyle(
                                        color: Colors.white,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              InkWell(
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'تفاصيل الأوامر',
                                    content: Obx(
                                      () => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...controller.pageCountList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                                int index = entry.key;
                                                PrintStats stat = entry.value;
                                                return Text(
                                                  'أمر ${index + 1}: ${stat.pages} صفحة × ${stat.copies} نسخة = ${stat.totalPages} صفحة',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                );
                                              }),
                                          const SizedBox(height: 10),
                                          Divider(),
                                          Text(
                                            controller.pageCounterSummary,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'اظهر التفاصيل',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
            }),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Highlite(String text) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lalezar(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

class PrinterListBuilder extends StatelessWidget {
  final PrinterInfo printerInfo;

  const PrinterListBuilder({super.key, required this.printerInfo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();
    final printer = printerInfo.printer;

    return Obx(() {
      bool isSelected =
          controller.selectedPrinter.value?.printer.name == printer.name;

      return InkWell(
        onTap: () {
          controller.selectPrinter(printerInfo);
          controller.ifAllSelected();
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                printer.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  printerInfo.status == 'Ready'
                      ? Text(
                        '🖨 ${printerInfo.status}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                      : Text(
                        '🖨 ${printerInfo.status}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 253, 17, 0),
                          fontSize: 12,
                        ),
                      ),
                  Container(
                    color: Colors.white,
                    width: 1,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  printerInfo.jobCount == 0
                      ? Text(
                        '📄 ${printerInfo.jobCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                      : Text(
                        '📄 ${printerInfo.jobCount}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 253, 17, 0),
                          fontSize: 12,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 10),
                          ],
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class MainBox extends StatelessWidget {
  final String text;
  const MainBox({super.key, required this.text});
  //? المتميز و المتفوق و التاسيس السليم
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();

    return Obx(() {
      bool isSelected = controller.mainPath.value == text;
      return InkWell(
        onTap: () {
          controller.getPageCount_controller();

          controller.mainPath.value = text;
          controller.getFiles();
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: 150,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.lalezar(
                color: Colors.white,
                fontSize: 20,
                // overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}

class SecondBox extends StatelessWidget {
  final String text;
  const SecondBox({super.key, required this.text});
  //? 3ب و 4ب و 5ب و 6ب و 1ع
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();

    return Obx(() {
      bool isSelected = controller.sacandPath.value == text;
      return InkWell(
        onTap: () {
          controller.sacandPath.value = text;
          controller.getFiles();
          controller.getPageCount_controller();
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 60,
          width: 150,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.lalezar(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      );
    });
  }
}

class ThirdBox extends StatelessWidget {
  final String text;
  const ThirdBox({super.key, required this.text});
  //? اسئله و اجابه
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();

    return Obx(() {
      bool isSelected = controller.thirdPath.value == text;
      return InkWell(
        onTap: () {
          controller.thirdPath.value = text;
          controller.getFiles();
          controller.getPageCount_controller();
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 80,
          width: 150,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.lalezar(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      );
    });
  }
}

class FourthBox extends StatelessWidget {
  final Map<String, dynamic> text;
  const FourthBox({super.key, required this.text});
  //? دين
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Controler>();

    return Obx(() {
      bool isSelected = controller.fourthPath.value == text['name'];
      return InkWell(
        onTap: () {
          controller.fourthPath.value = text['name'];

          controller.getPageCount_controller();
          controller.getFiles();
          controller.ifAllSelected();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: 100,
          child: Stack(
            children: [
              Center(
                child: Text(
                  text['name'],
                  style: GoogleFonts.lalezar(color: Colors.white, fontSize: 25),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text['pages'].toString(),
                        style: GoogleFonts.bebasNeue(
                          color: Colors.orange,
                          fontSize: 30,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              color: Colors.black,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),

                      Obx(() {
                        return Text(
                          '${(text['pages'] * controller.pricePerPage.value).toStringAsFixed(0)} \$',
                          style: GoogleFonts.bebasNeue(
                            color: Colors.green,
                            fontSize: 30,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
