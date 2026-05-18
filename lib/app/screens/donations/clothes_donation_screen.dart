import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/three_d_background.dart';

class ClothesDonationScreen extends StatefulWidget {
  const ClothesDonationScreen({super.key});

  @override
  State<ClothesDonationScreen> createState() => _ClothesDonationScreenState();
}

class _ClothesDonationScreenState extends State<ClothesDonationScreen> {
  String _selectedCategory = "Men's";
  final _descriptionController = TextEditingController();
  int _quantity = 1;
  String _condition = 'Good';
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (_selectedImages.length + images.length > 5) {
        Get.snackbar(
          'Limit Reached',
          'You can only upload up to 5 photos',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Donate Clothes'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: ThreeDBackground(
        isDark: isDark,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 16.0,
            bottom: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a category and tell us about your items.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip("Men's", Icons.person),
                    _buildCategoryChip("Women's", Icons.person_outline),
                    _buildCategoryChip("Children's", Icons.child_care),
                    _buildCategoryChip("Shoes", Icons.store),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.cyan,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Upload photos of your items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add up to 5 photos of the clothes you want to donate.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.cyan.withOpacity(0.5),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_selectedImages[index].path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    if (_selectedImages.isNotEmpty) const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _selectedImages.length >= 5
                          ? null
                          : _pickImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(
                        _selectedImages.isEmpty
                            ? 'Add Photos'
                            : 'Add More (${5 - _selectedImages.length} remaining)',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "e.g., Men's blue cotton t-shirt, size M",
                labelText: 'Item Description',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: '1',
                labelText: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text(
                'Condition',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardSecondary
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButton<String>(
                  value: _condition,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['Good', 'Very Good', 'Excellent', 'New'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _condition = value!),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: '123 Hope St, Anytown, USA',
                labelText: 'Pickup Address',
                prefixIcon: const Icon(Icons.location_on),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Schedule Pickup',
                onPressed: () {
                  if (_descriptionController.text.isEmpty) {
                    Get.snackbar(
                      'Missing Info',
                      'Please provide a description of the items',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // In a real app, we would upload the images and form data here

                  Get.dialog(
                    AlertDialog(
                      title: const Text('Thank You!'),
                      content: const Text(
                        'Your donation request has been received. We will contact you shortly for pickup.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            Get.back(); // Go back to home
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                width: double.infinity,
                gradientColors: const [AppColors.cyan, AppColors.blue],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = label),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.cyan
                    : AppColors.darkCardSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.cyan : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
