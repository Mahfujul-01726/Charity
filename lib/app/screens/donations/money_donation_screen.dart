import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/three_d_background.dart';

class MoneyDonationScreen extends StatefulWidget {
  const MoneyDonationScreen({super.key});

  @override
  State<MoneyDonationScreen> createState() => _MoneyDonationScreenState();
}

class _MoneyDonationScreenState extends State<MoneyDonationScreen> {
  String _selectedCategory = 'All';

  final campaigns = [
    {
      'title': 'Clean Water for Villages',
      'description':
          'Help us bring safe, clean drinking water to remote communities.',
      'raised': 11250,
      'goal': 15000,
      'daysLeft': 25,
      'category': 'Urgent',
    },
    {
      'title': 'Education for Every Child',
      'description':
          'Provide essential school supplies for underprivileged students.',
      'raised': 3200,
      'goal': 8000,
      'daysLeft': 40,
      'category': 'Education',
    },
    {
      'title': 'Reforest Our Planet',
      'description': 'Help us plant trees and restore vital forest ecosystems.',
      'raised': 18500,
      'goal': 20000,
      'daysLeft': 12,
      'category': 'Environment',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredCampaigns = _selectedCategory == 'All'
        ? campaigns
        : campaigns.where((c) => c['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Donate'),
        backgroundColor: Colors.transparent,
      ),
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          top: false, // We handle top padding manually for more control
          bottom: true, // Ensure bottom safe area is respected
          child: Column(
            children: [
              SizedBox(
                height:
                    kToolbarHeight + MediaQuery.of(context).padding.top + 10,
              ),
              // Category Filter
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: ['All', 'Urgent', 'Education', 'Environment'].map((
                    category,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: isDark
                            ? AppColors.darkCard
                            : Colors.grey[200],
                        selectedColor: AppColors.purple,
                        labelStyle: TextStyle(
                          color: _selectedCategory == category
                              ? Colors.white
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Campaign List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: filteredCampaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = filteredCampaigns[index];
                    final progress =
                        (campaign['raised'] as int) / (campaign['goal'] as int);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120, // Reduced height from 150
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: index == 0
                                    ? [AppColors.cyan, AppColors.blue]
                                    : index == 1
                                    ? [AppColors.purple, AppColors.pink]
                                    : [
                                        AppColors.gradientCyanStart,
                                        AppColors.success,
                                      ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.favorite,
                                size: 50, // Reduced icon size
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ), // Reduced padding from 20
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campaign['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16, // Slightly reduced font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  campaign['description'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13, // Slightly reduced font size
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Raised: \$${campaign['raised']}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.cyan,
                                      ),
                                    ),
                                    Text(
                                      'Goal: \$${campaign['goal']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.cyan,
                                  ),
                                  minHeight: 6, // Slightly reduced height
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${campaign['daysLeft']} Days Left',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  text: 'Donate Now',
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Thank You!'),
                                        content: Text(
                                          'Thank you for donating to "${campaign['title']}". Your support changes lives.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  width: double.infinity,
                                  height:
                                      40, // Specify reduced height for button
                                  gradientColors: const [
                                    AppColors.purple,
                                    AppColors.pink,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
