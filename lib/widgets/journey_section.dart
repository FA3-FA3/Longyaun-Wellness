import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// About page follow-up to [FounderSection]: a short "My Journey" story
/// beside a photo. Stacks vertically on narrow viewports.
class JourneySection extends StatelessWidget {
  const JourneySection({super.key});

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
                'assets/images/journey_photo.jpg',
                fit: BoxFit.cover,
              ),
            );
            const story = _JourneyStory();

            final shrunkPhoto = Center(
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: AspectRatio(aspectRatio: 2 / 3, child: photo),
              ),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  story,
                  const SizedBox(height: 32),
                  shrunkPhoto,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: story),
                const SizedBox(width: 48),
                Expanded(child: shrunkPhoto),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JourneyStory extends StatelessWidget {
  const _JourneyStory();

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(
      color: AppColors.aboutText,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 1.5,
    );
    final boldStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);
    final italicStyle = bodyStyle.copyWith(fontStyle: FontStyle.italic);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Journey',
          style: TextStyle(
            color: AppColors.aboutText,
            fontSize: 34,
            fontWeight: FontWeight.w400,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              const TextSpan(text: 'Before I began practicing '),
              TextSpan(text: 'Taiji', style: boldStyle),
              const TextSpan(text: ', I spent many years reading about '),
              TextSpan(text: 'Daoism', style: italicStyle),
              const TextSpan(text: ' and '),
              TextSpan(text: 'Zen Buddhism', style: italicStyle),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'The ideas fascinated me, but eventually I felt that understanding '
          'them intellectually was not enough. I wanted to experience them '
          'directly through practice.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),
        Text(
          'This search led me to China, where I dedicated myself to '
          'studying Taiji, Qi Gong, meditation, and traditional methods of '
          'cultivation. Through daily practice and guidance from my '
          'teachers, these arts gradually became part of my everyday life.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),
        Text(
          'I continue to study and train while sharing what I have '
          'learned with others.',
          style: bodyStyle,
        ),
      ],
    );
  }
}
