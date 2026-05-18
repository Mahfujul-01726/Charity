import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/three_d_background.dart';
import 'my_donations_screen.dart';
import 'saved_campaigns_screen.dart';
import 'payment_methods_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'security_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.put(ThemeController());
    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            userController.profileImage.value.isNotEmpty
                            ? (userController.profileImage.value.startsWith(
                                        'http',
                                      )
                                      ? NetworkImage(
                                          userController.profileImage.value,
                                        )
                                      : FileImage(
                                          File(
                                            userController.profileImage.value,
                                          ),
                                        ))
                                  as ImageProvider
                            : null,
                        child: userController.profileImage.value.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.purple,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImagePickerOptions(context, userController),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.cyan,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    userController.email.value,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.favorite, 'My Donations', () {
                        Get.to(() => const MyDonationsScreen());
                      }),
                      _buildMenuItem(Icons.bookmark, 'Saved Campaigns', () {
                        Get.to(() => const SavedCampaignsScreen());
                      }),
                      _buildMenuItem(Icons.payment, 'Payment Methods', () {
                        Get.to(() => const PaymentMethodsScreen());
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.person_outline, 'Edit Profile', () {
                        Get.to(() => const EditProfileScreen());
                      }),
                      _buildMenuItem(
                        Icons.notifications_outlined,
                        'Notifications',
                        () {
                          Get.to(() => const NotificationsScreen());
                        },
                      ),
                      _buildMenuItem(Icons.security, 'Security', () {
                        Get.to(() => const SecurityScreen());
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => SwitchListTile(
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: themeController.isDarkMode,
                      onChanged: (value) => themeController.toggleTheme(),
                      activeColor: AppColors.cyan,
                      activeTrackColor: AppColors.cyan.withOpacity(0.3),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      secondary: const Icon(
                        Icons.dark_mode,
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.help_outline, 'Help & Support', () {
                        Get.to(() => const HelpSupportScreen());
                      }),
                      _buildMenuItem(
                        Icons.logout,
                        'Logout',
                        () => userController.logout(),
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, UserController userController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Update Profile Photo',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.cyan),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  userController.updateProfileImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.cyan),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  userController.updateProfileImageFromCamera();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: color ?? AppColors.cyan),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
