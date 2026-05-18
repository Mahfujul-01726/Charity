import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/three_d_background.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ThreeDBackground(
        isDark: isDark,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.cyan, AppColors.blue],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.water_drop,
                      size: 80,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16.0,
                  bottom: 80.0, // Extra space for bottom nav
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clean Water for Rural Villages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Raised: \$11,250',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyan,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '75% Funded',
                                  style: TextStyle(
                                    color: AppColors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Goal: \$15,000',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: 0.75,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.cyan,
                            ),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '250 Donors',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '25 Days Left',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.success,
                          child: Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sarah Chen',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Organizer',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Verified',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: isDark
                                ? Colors.white
                                : AppColors.textDark,
                            unselectedLabelColor: AppColors.textSecondary,
                            indicatorColor: AppColors.cyan,
                            tabs: const [
                              Tab(text: 'Story'),
                              Tab(text: 'Updates'),
                              Tab(text: 'Donors'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(
                            height: 250,
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Text(
                                    'In the remote villages of the Sub-Saharan region, access to clean and safe drinking water is not a guarantee. Every day, families, especially women and children, walk for miles to collect water from contaminated sources. This not only leads to life-threatening waterborne diseases but also steals precious time that could be spent on education and building a better future.\n\nOur mission is simple but profound: to build three solar-powered water wells that will provide a sustainable source of clean water for over 5,000 people across three villages. Your donation can change lives, improve health, and empower an entire community for generations to come.',
                                    style: TextStyle(fontSize: 14, height: 1.6),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Recent updates will appear here',
                                  ),
                                ),
                                Center(child: Text('Recent donors list')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Recent Donors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDonorTile('John A.', '\$50'),
                    _buildDonorTile('Maria G.', '\$100'),
                    _buildDonorTile('Anonymous', '\$25'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: CustomButton(
          text: 'Donate Now',
          onPressed: () {},
          width: double.infinity,
          gradientColors: const [AppColors.orange, AppColors.pink],
        ),
      ),
    );
  }

  Widget _buildDonorTile(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.cyan,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
