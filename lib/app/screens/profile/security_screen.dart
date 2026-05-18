import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/three_d_background.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _twoFactorEnabled = false;
  bool _loginAlerts = true;
  bool _sessionTimeout = true;
  bool _rememberDevice = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ThreeDBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Security',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('Authentication', [
                        _buildSwitchTile(
                          'Two-Factor Authentication',
                          'Add an extra layer of security to your account',
                          Icons.security,
                          _twoFactorEnabled,
                          (value) => _toggleTwoFactor(value),
                        ),
                        _buildSwitchTile(
                          'Remember Device',
                          'Stay signed in on this device',
                          Icons.devices,
                          _rememberDevice,
                          (value) => setState(() => _rememberDevice = value),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('Security Alerts', [
                        _buildSwitchTile(
                          'Login Alerts',
                          'Get notified when someone logs into your account',
                          Icons.notifications_active,
                          _loginAlerts,
                          (value) => setState(() => _loginAlerts = value),
                        ),
                        _buildSwitchTile(
                          'Session Timeout',
                          'Automatically sign out after inactivity',
                          Icons.timer,
                          _sessionTimeout,
                          (value) => setState(() => _sessionTimeout = value),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('Password & Account', [
                        _buildActionTile(
                          'Change Password',
                          'Update your account password',
                          Icons.lock,
                          () => _showChangePasswordDialog(),
                        ),
                        _buildActionTile(
                          'Active Sessions',
                          'Manage devices where you\'re signed in',
                          Icons.devices_other,
                          () => _showActiveSessions(),
                        ),
                        _buildActionTile(
                          'Login History',
                          'View recent login activity',
                          Icons.history,
                          () => _showLoginHistory(),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSection('Privacy', [
                        _buildActionTile(
                          'Privacy Settings',
                          'Control your data and privacy preferences',
                          Icons.privacy_tip,
                          () => _showPrivacySettings(),
                        ),
                        _buildActionTile(
                          'Download Your Data',
                          'Request a copy of your personal information',
                          Icons.download,
                          () => _downloadData(),
                        ),
                        _buildActionTile(
                          'Delete Account',
                          'Permanently delete your account and data',
                          Icons.delete_forever,
                          () => _showDeleteAccountDialog(),
                          isDangerous: true,
                        ),
                      ]),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.shield, size: 48, color: AppColors.cyan),
                            const SizedBox(height: 16),
                            const Text(
                              'Security Tips',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Never share your password with anyone\n• Enable two-factor authentication\n• Regularly review your login activity\n• Keep your app updated to the latest version',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.cyan, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.cyan,
            activeTrackColor: AppColors.cyan.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDangerous = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDangerous
                    ? AppColors.error.withValues(alpha: 0.2)
                    : AppColors.cyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDangerous ? AppColors.error : AppColors.cyan,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDangerous ? AppColors.error : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDangerous ? AppColors.error : AppColors.cyan,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTwoFactor(bool value) {
    if (value) {
      Get.to(() => const TwoFactorSetupScreen());
    } else {
      setState(() => _twoFactorEnabled = false);
    }
  }

  void _showChangePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter current password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter new password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm new password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Password Changed',
                'Your password has been updated successfully',
                backgroundColor: AppColors.cyan,
                colorText: Colors.white,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Active Sessions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSessionItem(
              'This Device',
              'Realme RMX3195 • Current session',
              true,
            ),
            const SizedBox(height: 12),
            _buildSessionItem(
              'Chrome on Windows',
              'Last active 2 hours ago',
              false,
            ),
            const SizedBox(height: 12),
            _buildSessionItem('iPhone 13', 'Last active 3 days ago', false),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Updated',
                    'All other sessions have been terminated',
                    backgroundColor: AppColors.cyan,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Sign Out All Other Devices'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(String device, String details, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.smartphone : Icons.computer,
            color: AppColors.cyan,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () {
                Get.snackbar(
                  'Removed',
                  'Session terminated',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }

  void _showLoginHistory() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Login History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildHistoryItem(
              'Today',
              'Realme RMX3195 • Current location',
              '2:30 PM',
              Icons.check_circle,
              AppColors.success,
            ),
            const SizedBox(height: 8),
            _buildHistoryItem(
              'Today',
              'Chrome on Windows • New York, USA',
              '10:15 AM',
              Icons.check_circle,
              AppColors.success,
            ),
            const SizedBox(height: 8),
            _buildHistoryItem(
              'Yesterday',
              'iPhone 13 • London, UK',
              '6:45 PM',
              Icons.warning,
              AppColors.warning,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    String date,
    String details,
    String time,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    Get.to(() => const PrivacySettingsScreen());
  }

  void _downloadData() {
    Get.dialog(
      AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'Your data will be compiled and sent to your email within 24 hours. This includes all your personal information, donation history, and activity logs.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Request Submitted',
                'Your data download request has been submitted',
                backgroundColor: AppColors.cyan,
                colorText: Colors.white,
              );
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Account Deleted',
                'Your account has been permanently deleted',
                backgroundColor: AppColors.error,
                colorText: Colors.white,
              );
              Get.offAllNamed('/login');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class TwoFactorSetupScreen extends StatelessWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Setup Two-Factor Authentication',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Follow these steps to enable 2FA on your account:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.looks_one),
              title: Text('Install an authenticator app'),
              subtitle: Text('Google Authenticator or Authy'),
            ),
            ListTile(
              leading: Icon(Icons.looks_two),
              title: Text('Scan the QR code'),
              subtitle: Text('Use your authenticator app to scan'),
            ),
            ListTile(
              leading: Icon(Icons.looks_3),
              title: Text('Enter the verification code'),
              subtitle: Text('Complete the setup with the 6-digit code'),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Profile Visibility'),
              subtitle: Text('Make your profile visible to other users'),
              value: true,
              onChanged: null,
            ),
            SwitchListTile(
              title: Text('Show Donation History'),
              subtitle: Text('Display your donation history publicly'),
              value: false,
              onChanged: null,
            ),
            SwitchListTile(
              title: Text('Analytics'),
              subtitle: Text('Help us improve by sharing usage data'),
              value: true,
              onChanged: null,
            ),
            SwitchListTile(
              title: Text('Personalized Recommendations'),
              subtitle: Text(
                'Get campaign suggestions based on your interests',
              ),
              value: true,
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }
}
