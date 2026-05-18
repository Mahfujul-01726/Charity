import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  const GradientContainer({
    super.key,
    required this.child,
    this.colors,
    this.begin,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
          colors:
              colors ??
              [
                AppColors.gradientPurpleStart,
                AppColors.gradientBlueStart,
                AppColors.gradientCyanStart,
              ],
        ),
      ),
      child: child,
    );
  }
}
