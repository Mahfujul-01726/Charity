import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
  }

  void setDarkMode(bool value) {
    _isDarkMode.value = value;
  }
}
