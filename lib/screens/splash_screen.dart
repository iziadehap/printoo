import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_printer_app/screens/ActivationScreen.dart';
import 'package:my_printer_app/services/free_trial_protection_or_active.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_printer_app/controller/controler.dart';
import 'package:my_printer_app/screens/home_screen.dart';
import 'package:my_printer_app/screens/path_screen.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isActivationChecked = false;
  bool _showWelcomeText = true;
  bool _isNavigating = false;
  // Widget? _finalHome;
  final controller = Get.find<Controler>();
  final Random random = Random();
  final List<Offset> starPositions = [];
  final List<Map<String, dynamic>> cloudData = [];

  int? activationStatus = null;
  // bool isFreeTrialSaveIn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Generate random star positions
    for (int i = 0; i < 50; i++) {
      starPositions.add(
        Offset(
          random.nextDouble() * Get.width,
          random.nextDouble() * (Get.height * 0.7),
        ),
      );
    }

    // Generate cloud data once
    for (int i = 0; i < 6; i++) {
      cloudData.add({
        'width': 150.0 + random.nextDouble() * 50,
        'height': 80.0 + random.nextDouble() * 30,
        'startX': -200.0 + (random.nextDouble() * Get.width),
        'startY': 20.0 + random.nextDouble() * 120,
        'duration': 20 + random.nextInt(15),
        'image': 'assets/cloud ${1 + random.nextInt(3)}.png',
        'opacity': 0.5 + random.nextDouble() * 0.2,
      });
    }

    _controller.forward();
    _checkActivation();

    // Hide welcome text after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          if (activationStatus == 999 && activationStatus != null) gotoHome();

          _showWelcomeText = false;
        });
      }
    });
  }

  Future<void> _checkActivation() async {
    int activationStatus2 = await LicenseHelper.checkFreeTrialStatus();
    bool isFirstTime2 =
        LicenseHelper.isFirstTime; // Get the current isFirstTime value

    setState(() {
      activationStatus = activationStatus2;
      // If it's first time, force daysLeft to be 3
      if (isFirstTime2) {
        activationStatus = 3; // This will show 3 days for first time
      }
    });
  }

  Future<void> gotoHome() async {
    final finalHome =
        controller.isSavedPath.value == null
            ? const PathScreen()
            : const HomeScreen();

    Get.offAll(
      () => finalHome,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  // Future<void> changeFreeTrialToTrue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isFreeTrial', true);
  // }

  void _navigateToHome(bool trueToTryFree) {
    final finalHome =
        !trueToTryFree
            ? ActivationScreen()
            : controller.isSavedPath.value == null
            ? const PathScreen()
            : const HomeScreen();

    Get.offAll(
      () => finalHome,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleButtonPress(bool tryFree) async {
    if (_isNavigating) return;
    _isNavigating = true;

    if (tryFree == true) {
      // if (isFreeTrialSaveIn == false) {
      //   await changeFreeTrialToTrue();
      // }

      if (activationStatus == 0 && activationStatus != null) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber[900]?.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 40,
                      color: Colors.amber[100],
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Text(
                        'التفعيل مطلوب',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[100],
                          shadows: [
                            Shadow(
                              color: Colors.amber[100]!.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),
                  const SizedBox(height: 15),
                  Text(
                        'الرجاء التفعيل للاستمرار في الاستخدام',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                            onPressed: () {
                              Get.back();
                              setState(() {
                                _isNavigating = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'حسناً',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        ).then((_) {
          setState(() {
            _isNavigating = false;
          });
        });
      } else {
        _navigateToHome(true);
      }
    } else {
      _navigateToHome(false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      body: Stack(
        children: [
          // Background Stars
          ...List.generate(starPositions.length, (index) {
            return Positioned(
              left: starPositions[index].dx,
              top: starPositions[index].dy,
              child: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(
                    duration: (1000 + random.nextInt(2000)).ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .fadeOut(
                    duration: (1000 + random.nextInt(2000)).ms,
                    curve: Curves.easeInOut,
                  ),
            );
          }),

          // Night Clouds
          ...List.generate(cloudData.length, (index) {
            final cloud = cloudData[index];
            return Positioned(
              top: cloud['startY'],
              left: cloud['startX'],
              child: Opacity(
                    opacity: cloud['opacity'],
                    child: Image.asset(
                      cloud['image'],
                      width: cloud['width'],
                      height: cloud['height'],
                      fit: BoxFit.contain,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: const Duration(seconds: 1),
                  )
                  .then()
                  .moveX(
                    begin: cloud['startX'],
                    end: Get.width + 100,
                    duration: Duration(seconds: cloud['duration']),
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: const Duration(milliseconds: 500)),
            );
          }),

          // Moon
          Positioned(
            top: 50,
            right: 50,
            child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber[100]!.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.amber[100]!.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(seconds: 2),
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: const Duration(seconds: 2),
                ),
          ),

          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Welcome Text or Free/Pay Screen
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  _showWelcomeText
                      ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Text(
                            'مرحباً بك في برنامج Printoo\nطباعة سهلة، عمل سهل، حياة سهلة',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.amber[100]!.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(2, 2),
                                ),
                                Shadow(
                                  color: Colors.amber[100]!.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(-2, -2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      : FutureBuilder<int>(
                        future: LicenseHelper.checkFreeTrialStatus(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final daysLeft = snapshot.data;

                          // Skip showing subscription plan if activationStatus is 999
                          if (activationStatus == 999) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                    'اختر خطة الاشتراك',
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.amber.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: -0.2, end: 0),

                              const SizedBox(height: 70),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Free Trial Button
                                  SizedBox(
                                        width:
                                            300, // Fixed width for both buttons
                                        height: 120,
                                        child: ElevatedButton(
                                          onPressed:
                                              () => _handleButtonPress(true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[900],
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 60,
                                              vertical: 25,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              side: BorderSide(
                                                color: Colors.grey[700]!,
                                                width: 2,
                                              ),
                                            ),
                                            elevation: 8,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "تجربة مجانية",
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (activationStatus == 3)
                                                Text(
                                                  "3 أيام مجانية",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              else if (activationStatus !=
                                                      null &&
                                                  activationStatus! > 0)
                                                Text(
                                                  "متبقي $activationStatus يوم",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              else if (activationStatus == 0)
                                                Text(
                                                  "التجربة منتهية",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideX(begin: -0.2, end: 0),

                                  const SizedBox(width: 40),

                                  // Pay Button
                                  SizedBox(
                                        width:
                                            300, // Fixed width for both buttons
                                        height: 120,
                                        child: ElevatedButton(
                                          onPressed:
                                              () => _handleButtonPress(false),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber[900],
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 60,
                                              vertical: 25,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              side: BorderSide(
                                                color: Colors.amber[700]!,
                                                width: 2,
                                              ),
                                            ),
                                            elevation: 8,
                                          ),
                                          child: const Text(
                                            "شراء النسخة",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideX(begin: 0.2, end: 0),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class TouchTrailPainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> colors;

  TouchTrailPainter({required this.points, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final paint =
          Paint()
            ..color = colors[i % colors.length].withOpacity(0.5)
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round;

      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(TouchTrailPainter oldDelegate) => true;
}
