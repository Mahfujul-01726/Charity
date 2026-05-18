import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';
import '../../widgets/three_d_background.dart';
import '../../widgets/custom_button.dart';

class BloodDonationScreen extends StatefulWidget {
  const BloodDonationScreen({super.key});

  @override
  State<BloodDonationScreen> createState() => _BloodDonationScreenState();
}

class _BloodDonationScreenState extends State<BloodDonationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAvailableToDonate = false;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _contactController = TextEditingController();
  final _unitsController = TextEditingController();
  String _requestBloodType = 'A+';
  String _urgency = 'Normal';

  // Mock Data: Urgent Requests (People needing blood)
  final List<Map<String, dynamic>> _urgentRequests = [
    {
      'id': '1',
      'patient': 'Sarah Connor',
      'hospital': 'City General Hospital',
      'bloodType': 'O-',
      'units': 2,
      'urgency': 'Critical',
      'distance': '2.5 km',
      'timeAgo': '10 min ago',
    },
    {
      'id': '2',
      'patient': 'James Bond',
      'hospital': 'Memorial Medical Center',
      'bloodType': 'AB+',
      'units': 1,
      'urgency': 'Normal',
      'distance': '5.0 km',
      'timeAgo': '1 hour ago',
    },
    {
      'id': '3',
      'patient': 'Elena Fisher',
      'hospital': 'Children\'s Hospital',
      'bloodType': 'A+',
      'units': 3,
      'urgency': 'Critical',
      'distance': '8.2 km',
      'timeAgo': '2 hours ago',
    },
    {
      'id': '4',
      'patient': 'Robert Neville',
      'hospital': 'St. Mary\'s Hospital',
      'bloodType': 'O+',
      'units': 1,
      'urgency': 'Normal',
      'distance': '12 km',
      'timeAgo': '5 hours ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _patientNameController.dispose();
    _hospitalController.dispose();
    _contactController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Blood Donation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTabBar(isDark),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDonateTab(isDark), // Tab 1: Donate (View Requests)
                    _buildRequestTab(isDark), // Tab 2: Request (Ask for help)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.purple.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Donate Blood'),
          Tab(text: 'Request Blood'),
        ],
      ),
    );
  }

  // TAB 1: DONATE BLOOD (View Requests & Status)
  Widget _buildDonateTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        // 1. My Status Card
        _buildDonorStatusCard(),
        const SizedBox(height: 25),

        // 2. Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Urgent Needs Nearby',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 3. Requests List
        ..._urgentRequests.map((request) {
          return _buildRequestCard(request, isDark);
        }),
      ],
    );
  }

  Widget _buildDonorStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isAvailableToDonate
              ? [const Color(0xFF10B981), const Color(0xFF059669)] // Green
              : [const Color(0xFFEF4444), const Color(0xFFB91C1C)], // Red
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isAvailableToDonate ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAvailableToDonate
                      ? 'You are Available'
                      : 'Currently Unavailable',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isAvailableToDonate
                      ? 'Thanks for being a hero! You may be contacted.'
                      : 'Tap to mark yourself available to donate.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailableToDonate,
            onChanged: (val) {
              setState(() => _isAvailableToDonate = val);
              Get.snackbar(
                val ? 'Available to Donate' : 'Unavailable',
                val
                    ? 'You are now visible to those in need.'
                    : 'You have paused requests.',
                backgroundColor: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.all(20),
              );
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, bool isDark) {
    final isCritical = request['urgency'] == 'Critical';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Blood Group Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCritical
                      ? AppColors.error.withOpacity(0.2)
                      : AppColors.info.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isCritical ? AppColors.error : AppColors.info,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    request['bloodType'],
                    style: TextStyle(
                      color: isCritical ? AppColors.error : AppColors.info,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['hospital'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${request['distance']} • ${request['timeAgo']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient: ${request['patient']} • ${request['units']} Units',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Action
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: 'Confirm Donation',
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    middleText:
                        'Do you want to contact details for this request?',
                    textConfirm: 'Yes, I can help',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      Get.snackbar(
                        'Thank You!',
                        'Contact details have been shared.',
                        backgroundColor: Colors.white.withOpacity(0.9),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.pink, AppColors.purple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Donate',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isCritical)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'CRITICAL URGENCY - IMMEDIATELY REQUIRED',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // TAB 2: REQUEST BLOOD (Form)
  Widget _buildRequestTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Who needs help?'),
            const SizedBox(height: 15),
            _buildGlassTextField(
              controller: _patientNameController,
              label: 'Patient Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            _buildGlassTextField(
              controller: _hospitalController,
              label: 'Hospital Name',
              icon: Icons.local_hospital_outlined,
            ),
            const SizedBox(height: 25),

            _buildSectionTitle('Requirement Details'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildGlassDropdown(
                    value: _requestBloodType,
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                    label: 'Blood Type',
                    onChanged: (val) =>
                        setState(() => _requestBloodType = val!),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildGlassTextField(
                    controller: _unitsController,
                    label: 'Units',
                    icon: Icons.water_drop_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildGlassTextField(
              controller: _contactController,
              label: 'Contact Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 25),

            _buildSectionTitle('Urgency'),
            const SizedBox(height: 10),
            _buildUrgencySelector(),

            const SizedBox(height: 40),
            Center(
              child: CustomButton(
                text: 'Post Request',
                onPressed: _submitRequest,
                width: double.infinity,
                height: 50,
                icon: Icons.broadcast_on_personal_outlined,
                gradientColors: const [AppColors.blue, AppColors.cyan],
              ),
            ),
            // Safety Notice
            const SizedBox(height: 20),
            Text(
              'By posting, you agree to share these details with nearby donors.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGlassDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.darkBackground,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
          ),
          items: items
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildUrgencySelector() {
    return Row(
      children: ['Normal', 'Critical'].map((level) {
        final isSelected = _urgency == level;
        final color = level == 'Critical' ? AppColors.error : AppColors.info;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _urgency = level),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: level == 'Normal' ? 12 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? color : Colors.white.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    level == 'Critical'
                        ? Icons.warning_amber
                        : Icons.info_outline,
                    color: isSelected ? color : Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    level,
                    style: TextStyle(
                      color: isSelected ? color : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Request Sent',
        'Broadcasted to blood donors nearby.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white.withOpacity(0.9),
        colorText: Colors.black,
        margin: const EdgeInsets.all(20),
        icon: const Icon(Icons.check_circle, color: AppColors.success),
      );
      // clear form...
      _patientNameController.clear();
      _hospitalController.clear();
      _contactController.clear();
      _unitsController.clear();
    }
  }
}
