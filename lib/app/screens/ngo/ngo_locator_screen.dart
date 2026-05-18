import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/three_d_background.dart';

class NgoLocatorScreen extends StatefulWidget {
  const NgoLocatorScreen({super.key});

  @override
  State<NgoLocatorScreen> createState() => _NgoLocatorScreenState();
}

class _NgoLocatorScreenState extends State<NgoLocatorScreen> {
  final ngos = [
    {
      'name': 'Paws & Whiskers Sanctuary',
      'category': 'Animal Welfare',
      'distance': '1.2 miles away',
      'rating': 4.8,
    },
    {
      'name': 'Hope Community Center',
      'category': 'Community Support',
      'distance': '2.5 miles away',
      'rating': 4.9,
    },
    {
      'name': 'Green Earth Foundation',
      'category': 'Environment',
      'distance': '3.1 miles away',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ThreeDBackground(
        isDark: isDark,
        child: Stack(
          children: [
            // Map placeholder
            Container(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 100,
                      color: isDark
                          ? AppColors.textSecondary
                          : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark
                            ? AppColors.textSecondary
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard.withOpacity(0.8)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search by name or location',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Floating Action Buttons
            Positioned(
              right: 16,
              top: 120,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'filter',
                    mini: true,
                    backgroundColor: AppColors.purple,
                    onPressed: _showFilterDialog,
                    child: const Icon(Icons.filter_list, size: 20),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    heroTag: 'location',
                    mini: true,
                    backgroundColor: AppColors.cyan,
                    onPressed: _getCurrentLocation,
                    child: const Icon(Icons.my_location, size: 20),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton(
                    heroTag: 'messages',
                    mini: true,
                    backgroundColor: AppColors.blue,
                    onPressed: _showMessages,
                    child: const Icon(Icons.message, size: 20),
                  ),
                ],
              ),
            ),
            // Bottom Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    itemCount: ngos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                      final ngo = ngos[index - 1];
                      return _buildNgoCard(ngo, isDark);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNgoCard(Map<String, dynamic> ngo, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardSecondary
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.business, color: AppColors.purple, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ngo['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  ngo['category'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        ngo['distance'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '${ngo['rating']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _showNgoDetails(ngo, isDark),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: () => _showDonateDialog(ngo),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cyan),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Donate',
                    style: TextStyle(fontSize: 11, color: AppColors.cyan),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNgoDetails(Map<String, dynamic> ngo, bool isDark) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ngo['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.business, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Category', ngo['category'], Icons.category),
              _buildDetailRow('Distance', ngo['distance'], Icons.location_on),
              _buildDetailRow('Rating', '${ngo['rating']}', Icons.star),
              const SizedBox(height: 16),
              const Text(
                'This NGO is dedicated to helping the community through various initiatives and programs. Contact them for more details about their work and how you can contribute.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _makePhoneCall();
                    },
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _openMaps();
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonateDialog(Map<String, dynamic> ngo) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Donate to NGO',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${ngo['name']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose your donation method:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.money, color: Colors.green),
                    title: const Text('Cash Donation'),
                    subtitle: const Text('Handover directly'),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Cash Donation',
                        'Please visit the NGO location to handover your donation',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.blue),
                    title: const Text('Online Payment'),
                    subtitle: const Text('Transfer via banking app'),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Online Payment',
                        'Redirecting to payment gateway...',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.card_giftcard, color: Colors.purple),
                    title: const Text('Goods Donation'),
                    subtitle: const Text('Donate items directly'),
                    onTap: () {
                      Get.back();
                      Get.snackbar(
                        'Goods Donation',
                        'Please bring your donated items to the NGO location',
                        backgroundColor: Colors.purple,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall() {
    // In a real app, this would open the phone dialer
    Get.snackbar(
      'Phone Call',
      'Calling NGO...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _openMaps() {
    // In a real app, this would open maps with the NGO location
    Get.snackbar(
      'Navigation',
      'Opening maps to get directions...',
      backgroundColor: AppColors.blue,
      colorText: Colors.white,
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter NGOs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select categories:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Animal Welfare'),
                    value: true,
                    onChanged: (value) {},
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('Community Support'),
                    value: true,
                    onChanged: (value) {},
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('Environment'),
                    value: false,
                    onChanged: (value) {},
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('Education'),
                    value: false,
                    onChanged: (value) {},
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('Healthcare'),
                    value: false,
                    onChanged: (value) {},
                    dense: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Filter Applied',
                        'Showing filtered NGOs',
                        backgroundColor: AppColors.purple,
                        colorText: Colors.white,
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    Get.snackbar(
      'Location',
      'Getting your current location...',
      backgroundColor: AppColors.cyan,
      colorText: Colors.white,
    );
    // In a real app, this would get the actual GPS location
    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Location Updated',
        'Showing NGOs near your location',
        backgroundColor: AppColors.cyan,
        colorText: Colors.white,
      );
    });
  }

  void _showMessages() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No new messages',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.purple,
                  child: Icon(Icons.support_agent, color: Colors.white),
                ),
                title: const Text('NGO Support'),
                subtitle: const Text('Need help? Chat with our support team'),
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Support Chat',
                    'Connecting to support team...',
                    backgroundColor: AppColors.purple,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
