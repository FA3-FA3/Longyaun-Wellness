import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_colors.dart';
import '../utils/social_links.dart';

const _introVideoUrl = 'https://youtu.be/1h10UDCnjtw?si=lttn9ZlU8dL-GQBZ';
const _introVideoThumbnail = 'https://img.youtube.com/vi/1h10UDCnjtw/hqdefault.jpg';

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }
}

/// Learn With Me page: free intro course blurb, a link to the YouTube
/// channel (same URL as the footer), and a clickable video preview.
class FreeResourcesSection extends StatelessWidget {
  const FreeResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyStyle = TextStyle(
      color: AppColors.aboutText,
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 1.5,
    );

    return ColoredBox(
      color: AppColors.aboutBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Free Resources',
              style: TextStyle(
                color: AppColors.aboutText,
                fontSize: 34,
                fontWeight: FontWeight.w400,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Free Introductory Course',
              style: bodyStyle.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _openUrl(SocialLinks.youtube),
              child: Text(
                'Watch more on YouTube',
                style: TextStyle(
                  color: AppColors.navTextActive,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _VideoPreview(),
          ],
        ),
      ),
    );
  }
}

class _VideoPreview extends StatelessWidget {
  const _VideoPreview();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InkWell(
          onTap: () => _openUrl(_introVideoUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _introVideoThumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      ColoredBox(color: AppColors.navBackground),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.15)),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
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
