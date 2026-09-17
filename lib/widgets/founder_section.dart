import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// About page founder introduction: photo beside a short bio. Stacks
/// vertically on narrow viewports instead of squeezing side by side.
class FounderSection extends StatelessWidget {
  const FounderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.aboutBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 700;
            final photo = ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                'assets/images/founder_photo.jpg',
                fit: BoxFit.cover,
              ),
            );
            final bio = const _FounderBio();

            final shrunkPhoto = Center(
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: AspectRatio(aspectRatio: 4 / 5, child: photo),
              ),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  shrunkPhoto,
                  const SizedBox(height: 32),
                  bio,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: shrunkPhoto),
                const SizedBox(width: 48),
                Expanded(child: bio),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FounderBio extends StatelessWidget {
  const _FounderBio();

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(
      color: AppColors.aboutText,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 1.5,
    );
    final boldStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello! I'm Thomas.",
          style: TextStyle(
            color: AppColors.aboutText,
            fontSize: 40,
            fontWeight: FontWeight.w400,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Founder of Longyuan (龙元) Wellness',
          style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              TextSpan(text: 'Longyuan Wellness', style: boldStyle),
              const TextSpan(
                text:
                    ' is a place where I share the practices that have '
                    'become an important part of my life: ',
              ),
              TextSpan(text: 'Taiji', style: boldStyle),
              const TextSpan(text: ' and '),
              TextSpan(text: 'Qi Gong', style: boldStyle),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'For almost 3 years I have studied (and still study) these arts '
          'both independently and through full-time training in China '
          'under experienced teachers. What began as an interest in '
          'Daoist philosophy gradually became a practical path of '
          'training and self-cultivation.',
          style: bodyStyle,
        ),
      ],
    );
  }
}
