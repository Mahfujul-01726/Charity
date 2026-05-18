import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGradient;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGradient = true,
    this.gradientColors,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 40, // Further reduced from 48 to 40 for even smaller size
      decoration: BoxDecoration(
        gradient: isGradient && !isOutlined
            ? LinearGradient(
                colors: gradientColors ?? [AppColors.cyan, AppColors.blue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: !isGradient && !isOutlined
            ? (backgroundColor ?? AppColors.purple)
            : null,
        borderRadius: BorderRadius.circular(20), // Even smaller radius
        border: isOutlined ? Border.all(color: AppColors.cyan, width: 2) : null,
        boxShadow: [
          // Add subtle shadow for depth
          if (!isOutlined)
            BoxShadow(
              color: (gradientColors ?? [AppColors.cyan, AppColors.blue]).first.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2), // More subtle splash effect
          highlightColor: Colors.white.withOpacity(0.1), // Highlight when pressed
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor ?? Colors.white, size: 16), // Even smaller icon
                  const SizedBox(width: 4),
                ],
                Text(
                  text,
                  style: AppTextStyles.button.copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: 12, // Even smaller font
                    fontWeight: FontWeight.w600, // Slightly bolder
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
