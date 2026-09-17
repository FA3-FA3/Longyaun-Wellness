import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/free_resources_section.dart';
import '../widgets/placeholder_section.dart';

class LearnWithMePage extends StatelessWidget {
  const LearnWithMePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colored behind the whole page so any hairline gap between sections
    // reveals this same dark backdrop instead of the lighter Scaffold
    // background (see AboutPage for the same fix).
    return ColoredBox(
      color: AppColors.aboutBackground,
      child: Column(
        children: [
          const FreeResourcesSection(),
          _sectionDivider(),
          const PlaceholderSection(heading: 'Private Lessons'),
          _sectionDivider(),
          const PlaceholderSection(heading: 'Courses: Structured Online Learning'),
        ],
      ),
    );
  }

  Widget _sectionDivider() {
    return Container(
      height: 1,
      color: AppColors.aboutText.withValues(alpha: 0.15),
    );
  }
}
