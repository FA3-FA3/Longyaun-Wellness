import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Generic content-pending section: a heading on the site's dark editorial
/// backdrop, with a placeholder note until real copy is written.
class PlaceholderSection extends StatelessWidget {
  const PlaceholderSection({super.key, required this.heading});

  final String heading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.aboutBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              heading,
              style: TextStyle(
                color: AppColors.aboutText,
                fontSize: 34,
                fontWeight: FontWeight.w400,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Content coming soon.',
              style: TextStyle(
                color: AppColors.aboutText.withValues(alpha: 0.5),
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
