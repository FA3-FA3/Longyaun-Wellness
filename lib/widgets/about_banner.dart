import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Full-width photo banner shown above the About page's text sections.
class AboutBanner extends StatelessWidget {
  const AboutBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 542,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/about_banner.jpg',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.aboutBackground,
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
          // Guaranteed fully-opaque strip so the banner meets the section
          // below in solid color, regardless of any gradient rounding at
          // the very last pixel row.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 8,
            child: ColoredBox(color: AppColors.aboutBackground),
          ),
        ],
      ),
    );
  }
}
