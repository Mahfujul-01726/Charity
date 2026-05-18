import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_controller.dart';

// Controller for managing user profile state

class UserController extends GetxController {
  final name = 'Aria Montgomery'.obs;
  final email = 'aria.montgomery@email.com'.obs;
  final phone = '+1 (555) 123-4567'.obs;
  final address = '123 Main Street, City, State 12345'.obs;
  final bio =
      'Passionate about making a difference in the community through charitable giving and volunteering.'
          .obs;
  final gender = 'Female'.obs;
  final birthDate = DateTime.now().subtract(const Duration(days: 365 * 25)).obs;
  final profileImage = ''.obs; // Empty string means default placeholder
  final ImagePicker _picker = ImagePicker();

  void updateUserProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newAddress,
    required String newBio,
    required String newGender,
    required DateTime newBirthDate,
    String? newProfileImagePath,
  }) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
    address.value = newAddress;
    bio.value = newBio;
    gender.value = newGender;
    birthDate.value = newBirthDate;
    if (newProfileImagePath != null) {
      profileImage.value = newProfileImagePath;
    }

    update(); // Notify listeners
  }

  Future<void> updateProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        profileImage.value = pickedFile.path;
        update(); // Notify listeners

        Get.snackbar(
          'Success',
          'Profile photo updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile photo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateProfileImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        profileImage.value = pickedFile.path;
        update(); // Notify listeners

        Get.snackbar(
          'Success',
          'Profile photo updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile photo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    // Here you would typically clear tokens, user data, etc.
    // Get.delete<UserController>(); // Optional: if you want to reset state

    await AuthController.instance.logout();

    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
