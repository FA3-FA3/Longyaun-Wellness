import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// About page follow-up to [JourneySection]: what the practice itself
/// consists of, beside a photo. Stacks vertically on narrow viewports.
class PracticeSection extends StatelessWidget {
  const PracticeSection({super.key});

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
                'assets/images/practice_photo.jpg',
                fit: BoxFit.cover,
              ),
            );
            const description = _PracticeDescription();

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
                  shrunkPhoto,
                  const SizedBox(height: 32),
                  description,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: shrunkPhoto),
                const SizedBox(width: 48),
                const Expanded(child: description),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PracticeDescription extends StatelessWidget {
  const _PracticeDescription();

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
          'Practice',
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
              const TextSpan(text: 'My practice is centred around '),
              TextSpan(text: 'Wudang Taiji', style: boldStyle),
              const TextSpan(text: ' within the '),
              TextSpan(text: 'Sanfeng Pai lineage', style: boldStyle),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              const TextSpan(text: 'While the Wudang tradition includes both '),
              TextSpan(text: 'internal', style: italicStyle),
              const TextSpan(text: ' and '),
              TextSpan(text: 'external arts (Wushu)', style: italicStyle),
              const TextSpan(
                text:
                    ', my primary interest lies in the internal side of the '
                    'system: Taiji, Qi Gong, meditation, and the process of '
                    'self-cultivation that accompanies them.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'What continues to inspire me about these practices is their '
          'emphasis on relaxation, awareness, and working with the body '
          'rather than against it. Through consistent practice, they offer '
          'a way to cultivate balance not only in movement, but also in '
          'daily life.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),
        Text(
          'Many of the traditional teachings speak of refining and '
          'harmonising the Three Treasures — Jing, Qi, and Shen — concepts '
          'that point toward the relationship between vitality, energy, '
          'and spirit. While these ideas can be explored in many ways, I '
          'see them primarily as a guide for practice rather than '
          'something to be understood only through theory.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),
        Text(
          'As a student, I continue to learn from my teachers and deepen '
          'my understanding of these arts through ongoing training and '
          'study.',
          style: bodyStyle,
        ),
      ],
    );
  }
}
