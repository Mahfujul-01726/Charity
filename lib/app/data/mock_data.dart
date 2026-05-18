import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/donations/blood_donation_screen.dart';
import '../screens/donations/clothes_donation_screen.dart';
import '../screens/donations/education_donation_screen.dart';
import '../screens/donations/electronics_donation_screen.dart';
import '../screens/donations/environment_donation_screen.dart';
import '../screens/donations/food_donation_screen.dart';
import '../screens/donations/furniture_donation_screen.dart';
import '../screens/donations/gifts_donation_screen.dart';
import '../screens/donations/medicine_donation_screen.dart';
import '../screens/donations/money_donation_screen.dart';
import '../screens/ngo/ngo_locator_screen.dart';

final List<Map<String, dynamic>> campaigns = [
  {
    'title': 'Winter Collection',
    'subtitle': 'Distributing warm clothes to 500+ families.',
    'progressLabel': '75%',
    'progress': 0.75,
    'imageUrl':
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80',
  },
  {
    'title': 'Education for All',
    'subtitle': 'Providing books and supplies to rural schools.',
    'progressLabel': '40%',
    'progress': 0.40,
    'imageUrl':
        'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=800&q=80',
  },
  {
    'title': 'Feed the Hungry',
    'subtitle': 'Daily meals for the homeless community.',
    'progressLabel': '60%',
    'progress': 0.60,
    'imageUrl':
        'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=800&q=80',
  },
  {
    'title': 'Medical Aid',
    'subtitle': 'Free checkups and medicine for the poor.',
    'progressLabel': '25%',
    'progress': 0.25,
    'imageUrl':
        'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=800&q=80',
  },
  {
    'title': 'Clean Water',
    'subtitle': 'Installing tube wells in drought areas.',
    'progressLabel': '90%',
    'progress': 0.90,
    'imageUrl':
        'https://images.unsplash.com/photo-1538300342682-cf57afb97285?auto=format&fit=crop&w=800&q=80',
  },
];

final List<Map<String, dynamic>> categories = [
  {
    'title': 'Blood',
    'subtitle': 'Save Lives',
    'icon': Icons.water_drop,
    'color': const Color(0xFFEF4444),
    'onTap': () => Get.to(() => const BloodDonationScreen()),
  },
  {
    'title': 'Food',
    'subtitle': 'Feed Hungry',
    'icon': Icons.restaurant,
    'color': const Color(0xFFF59E0B),
    'onTap': () => Get.to(() => const FoodDonationScreen()),
  },
  {
    'title': 'Clothes',
    'subtitle': 'Spread Warmth',
    'icon': Icons.checkroom,
    'color': const Color(0xFF8B5CF6),
    'onTap': () => Get.to(() => const ClothesDonationScreen()),
  },
  {
    'title': 'Medicine',
    'subtitle': 'Heal Care',
    'icon': Icons.medical_services,
    'color': const Color(0xFF10B981),
    'onTap': () => Get.to(() => const MedicineDonationScreen()),
  },
  {
    'title': 'Fund',
    'subtitle': 'Support Us',
    'icon': Icons.volunteer_activism,
    'color': const Color(0xFF3B82F6),
    'onTap': () => Get.to(() => const MoneyDonationScreen()),
  },
  {
    'title': 'NGOs',
    'subtitle': 'Locate Help',
    'icon': Icons.map,
    'color': const Color(0xFF6366F1),
    'onTap': () => Get.to(() => const NgoLocatorScreen()),
  },
  {
    'title': 'Education',
    'subtitle': 'Build Future',
    'icon': Icons.school,
    'color': Colors.orange,
    'onTap': () => Get.to(() => const EducationDonationScreen()),
  },
  {
    'title': 'Gifts',
    'subtitle': 'Share Joy',
    'icon': Icons.card_giftcard,
    'color': Colors.pink,
    'onTap': () => Get.to(() => const GiftsDonationScreen()),
  },
  {
    'title': 'Electronics',
    'subtitle': 'Reuse Tech',
    'icon': Icons.devices_other,
    'color': Colors.teal,
    'onTap': () => Get.to(() => const ElectronicsDonationScreen()),
  },
  {
    'title': 'Furniture',
    'subtitle': 'Home Comfort',
    'icon': Icons.chair,
    'color': Colors.brown,
    'onTap': () => Get.to(() => const FurnitureDonationScreen()),
  },
  {
    'title': 'Environment',
    'subtitle': 'Plant Trees',
    'icon': Icons.forest,
    'color': Colors.green,
    'onTap': () => Get.to(() => const EnvironmentDonationScreen()),
  },
];
