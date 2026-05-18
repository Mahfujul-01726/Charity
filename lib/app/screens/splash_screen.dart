import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../widgets/three_d_background.dart';
import 'auth/login_screen.dart';
import 'onboarding_screen.dart';
import 'home/home_screen.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _controller;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State
  bool _isLoading = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeAndInitialize();
  }

  Future<void> _checkFirstTimeAndInitialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _startStandardAnimation();
    }
  }

  void _startStandardAnimation() {
    // 1. Setup Animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
          ),
        );

    // 2. Start Logic
    _controller.forward();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    // 3. Wait and Navigate
    Timer(const Duration(milliseconds: 3500), _completeSplash);
  }

  Future<void> _completeSplash() async {
    if (_isFirstTime) {
      Get.off(() => const OnboardingScreen());
    } else if (AuthController.instance.firebaseUser.value != null) {
      Get.off(() => const HomeScreen());
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    // Only dispose standard controllers if they were initialized
    if (!_isLoading) {
      try {
        _controller.dispose();
        _rippleController.dispose();
      } catch (e) {
        // Ignore "LateInitializationError" during disposal
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 0. Loading State - Return empty container to prevent LateInitializationError
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // Or app background color
        body: Center(child: SizedBox()),
      );
    }

    // 1. Standard Animation UI
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_controller, _rippleController]),
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: RipplePainter(
                            _rippleController.value,
                            AppColors.purple.withOpacity(0.3),
                          ),
                          size: const Size(200, 200),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 160, // Increased size for the image
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purple.withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/splash_hero_1765562963226.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.volunteer_activism,
                                    size: 60,
                                    color: AppColors.purple,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            const Text(
                              'HelpConnect',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Uniting Hands, Transforming Lives',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double value;
  final Color color;

  RipplePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      double radius = size.width / 2 * ((value + i / 3) % 1.0);
      double opacity = 1.0 - ((value + i / 3) % 1.0);
      paint.color = color.withOpacity(opacity * 0.5);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
