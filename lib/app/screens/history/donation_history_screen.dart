import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/three_d_background.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Donation History'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ThreeDBackground(
        isDark: isDark,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 20.0,
            bottom: 20.0,
          ),
          children: [
            _buildMonthHeader('August 2024'),
            _buildDonationItem(
              'Clean Water Initiative',
              'August 15, 2024',
              '\$25.00',
              true,
              isDark,
            ),
            _buildDonationItem(
              'Wildlife Rescue Fund',
              'August 10, 2024',
              '\$50.00',
              false,
              isDark,
            ),
            _buildDonationItem(
              'Community Food Bank',
              'August 02, 2024',
              '\$15.00',
              false,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildMonthHeader('July 2024'),
            _buildDonationItem(
              'Disaster Relief',
              'July 28, 2024',
              '\$75.00',
              false,
              isDark,
            ),
            _buildDonationItem(
              'Animal Shelter Support',
              'July 19, 2024',
              '\$30.00',
              false,
              isDark,
            ),
            _buildDonationItem(
              'Global Education Drive',
              'July 05, 2024',
              '\$100.00',
              false,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              month,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationItem(
    String title,
    String date,
    String amount,
    bool isFirst,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.cyan,
                shape: BoxShape.circle,
              ),
            ),
            if (!isFirst)
              Container(width: 2, height: 80, color: AppColors.cyan),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
