import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:my_printer_app/screens/splash_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:my_printer_app/services/statistics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Initialize StatisticsService
  await StatisticsService.instance.initialize();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 600),
    minimumSize: Size(1200, 650),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: "Printoo App",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(Controler());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
