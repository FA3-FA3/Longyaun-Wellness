import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/about_banner.dart';
import '../widgets/founder_section.dart';
import '../widgets/journey_section.dart';
import '../widgets/practice_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colored behind the whole page (not just each section) so any
    // hairline sub-pixel gap between sibling widgets reveals this same
    // dark backdrop instead of the lighter Scaffold background.
    return ColoredBox(
      color: AppColors.aboutBackground,
      child: const Column(
        children: [
          AboutBanner(),
          FounderSection(),
          JourneySection(),
          PracticeSection(),
        ],
      ),
    );
  }
}
