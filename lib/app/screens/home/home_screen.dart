import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';
import '../../widgets/three_d_background.dart';
import '../../controllers/user_controller.dart';

import '../history/donation_history_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/notifications_screen.dart';

import '../request/create_request_screen.dart';
import '../contact/contact_us_screen.dart';
import '../../widgets/category_card.dart';
import 'all_categories_screen.dart';
import '../../data/mock_data.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  int _currentBannerIndex = 0;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000, viewportFraction: 0.92);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground.withOpacity(0.6)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatsRow(isDark),
                            const SizedBox(height: 25),
                            _buildSectionHeader(
                              'Featured Campaigns',
                              isDark,
                              showSeeAll: false,
                            ),
                            const SizedBox(height: 15),
                            _buildCampaignCarousel(isDark),
                            const SizedBox(height: 25),
                            _buildSectionHeader(
                              'Donation Categories',
                              isDark,
                              onSeeAllTap: () => Get.to(
                                () =>
                                    AllCategoriesScreen(categories: categories),
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildCategoryGrid(context, isDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  userController.name.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.headset_mic_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.to(() => const ContactUsScreen()),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.to(() => const NotificationsScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Donations',
            '12',
            Icons.favorite_rounded,
            Colors.redAccent,
            isDark,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatItem(
            'Impact',
            '35+',
            Icons.public,
            Colors.blueAccent,
            isDark,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatItem(
            'Hours',
            '48h',
            Icons.schedule,
            Colors.orangeAccent,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : Colors.white.withOpacity(0.2), // Glassy card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Always white
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    bool isDark, {
    bool showSeeAll = true,
    VoidCallback? onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Always white
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9), // Lighter
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCampaignCarousel(bool isDark) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          PageView.builder(
            padEnds: false,
            controller: _pageController,
            // Infinite item count
            itemBuilder: (context, index) {
              final campaignIndex = index % campaigns.length;
              final campaign = campaigns[campaignIndex];
              return _buildFeaturedCard(
                campaign['title'],
                campaign['subtitle'],
                campaign['progressLabel'],
                campaign['progress'],
                campaign['imageUrl'],
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index % campaigns.length;
              });
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(campaigns.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: 4,
                  width: _currentBannerIndex == index ? 16 : 4,
                  decoration: BoxDecoration(
                    color: _currentBannerIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(
    String title,
    String subtitle,
    String progressLabel,
    double progress,
    String imageUrl,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  stops: const [0.7, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            color: AppColors.pink,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        progressLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, bool isDark) {
    // Show only the first 6 categories on home screen
    final displayCategories = categories.take(6).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];
        return CategoryCard(
          title: category['title'],
          subtitle: category['subtitle'],
          icon: category['icon'],
          color: category['color'],
          isDark: isDark,
          onTap:
              category['onTap'] ??
              () {
                Get.snackbar(
                  'Coming Soon',
                  '${category['title']} donation feature is coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  colorText: isDark ? Colors.white : Colors.black,
                );
              },
        );
      },
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      width: double.infinity,
      height: 80, // Slightly increased height for better proportions
      decoration: BoxDecoration(
        // Enhanced glassy effect with more transparency
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E293B).withOpacity(0.5),
                  const Color(0xFF1E293B).withOpacity(0.7),
                ]
              : [
                  AppColors.purple.withOpacity(0.1),
                  AppColors.purple.withOpacity(0.3),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, -10),
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            // Additional glassy overlay
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: Container(
                height: 70, // Slightly improved height for breathe room
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, 'Home', isDark),
                    _buildNavItem(1, Icons.search_rounded, 'Search', isDark),
                    _buildCenterFab(),
                    _buildNavItem(2, Icons.history_rounded, 'History', isDark),
                    _buildNavItem(3, Icons.person_rounded, 'Profile', isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            break;
          case 1:
            Get.to(() => const SearchScreen());
            break;
          case 2:
            Get.to(() => const DonationHistoryScreen());
            break;
          case 3:
            Get.to(() => const ProfileScreen());
            break;
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with Gradient Mask if selected
          isSelected
              ? ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.purple, AppColors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Icon(icon, size: 26, color: Colors.white),
                )
              : Icon(
                  icon,
                  size: 26,
                  color: isDark ? Colors.white60 : Colors.grey,
                ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.pink
                  : (isDark ? Colors.white60 : Colors.grey),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterFab() {
    return GestureDetector(
      onTap: () => Get.to(() => const CreateRequestScreen()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center vertically in the bar
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.purple, AppColors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4), // Match spacing of other items
          const Text(
            'Request',
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
