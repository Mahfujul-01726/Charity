import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/three_d_background.dart';
import 'auth/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Connect. Contribute.\nChange.',
      description:
          'Discover and support causes you care\nabout, all in one place.',
      imagePath: 'assets/images/onboarding_1_1765566072655.png',
      backgroundColor: [
        AppColors.gradientPurpleStart,
        AppColors.gradientBlueStart,
        AppColors.gradientCyanStart,
      ],
    ),
    OnboardingPage(
      title: 'Find Causes You\nLove',
      description:
          'Our smart system helps you discover and\nconnect with charities that match your\npassions.',
      imagePath: 'assets/images/onboarding_2_1765566088347.png',
      backgroundColor: [
        AppColors.gradientCyanStart,
        AppColors.gradientBlueEnd,
        AppColors.purple,
      ],
    ),
    OnboardingPage(
      title: 'Ready to Make a\nDifference?',
      description:
          'Tap below to explore causes,\nconnect with communities, and\nstart your giving journey.',
      imagePath: 'assets/images/onboarding_3_1765566106781.png',
      backgroundColor: [
        AppColors.purple,
        AppColors.gradientBlueStart,
        AppColors.gradientCyanStart,
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Get.off(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: ThreeDBackground(
        isDark: isDark,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
            Positioned(
              top: 60,
              right: 20,
              child: TextButton(
                onPressed: _skip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Dot Indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ScrollingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white24,
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotScale: 1.4,
                    spacing: 12,
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Image placeholder
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    page.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons
                              .image_not_supported_rounded, // Changed icon to indicate missing image
                          size: 100,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    page.title,
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (_currentPage == _pages.length - 1) ...[
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Get Started',
                      onPressed: _skip,
                      width: double.infinity,
                      height: 50,
                      gradientColors: [
                        Colors.white,
                        Colors.white.withOpacity(0.9),
                      ],
                      textColor: AppColors.purple,
                      isOutlined: false,
                    ),
                  ] else ...[
                    const SizedBox(height: 20), // Extra padding at bottom
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final List<Color> backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}
