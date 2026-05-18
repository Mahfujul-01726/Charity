import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/three_d_background.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'Credit Card',
      lastFour: '1234',
      expiryDate: '12/25',
      brand: 'Visa',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: 'Credit Card',
      lastFour: '5678',
      expiryDate: '09/24',
      brand: 'Mastercard',
      isDefault: false,
    ),
    PaymentMethod(
      id: '3',
      type: 'Bank Account',
      lastFour: '7890',
      expiryDate: '',
      brand: 'Chase Bank',
      isDefault: false,
    ),
  ];

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
                      'Payment Methods',
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
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final method = paymentMethods[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: method.isDefault
                                  ? Border.all(color: AppColors.cyan, width: 2)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getPaymentIcon(method.brand),
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            method.brand,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (method.isDefault) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.cyan,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Text(
                                                'Default',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        method.type == 'Credit Card'
                                            ? '•••• ${method.lastFour}'
                                            : '••••${method.lastFour}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (method.expiryDate.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Expires ${method.expiryDate}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'default') {
                                      setState(() {
                                        for (var m in paymentMethods) {
                                          m.isDefault = false;
                                        }
                                        method.isDefault = true;
                                      });
                                      Get.snackbar(
                                        'Updated',
                                        'Default payment method changed',
                                        backgroundColor: AppColors.cyan,
                                        colorText: Colors.white,
                                      );
                                    } else if (value == 'delete') {
                                      setState(() {
                                        paymentMethods.remove(method);
                                      });
                                      Get.snackbar(
                                        'Removed',
                                        'Payment method removed',
                                        backgroundColor: AppColors.cyan,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (!method.isDefault)
                                      const PopupMenuItem(
                                        value: 'default',
                                        child: Text('Set as Default'),
                                      ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _showAddPaymentMethodDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cyan,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Payment Method',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your payment information is encrypted and secure',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple pay':
        return Icons.apple;
      case 'google pay':
        return Icons.g_mobiledata;
      default:
        return Icons.account_balance;
    }
  }

  void _showAddPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Coming Soon',
                  'Credit card payment method addition will be available soon',
                  backgroundColor: AppColors.cyan,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Account'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Coming Soon',
                  'Bank account addition will be available soon',
                  backgroundColor: AppColors.cyan,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('PayPal'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar(
                  'Coming Soon',
                  'PayPal integration will be available soon',
                  backgroundColor: AppColors.cyan,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String lastFour;
  final String expiryDate;
  final String brand;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.expiryDate,
    required this.brand,
    this.isDefault = false,
  });
}