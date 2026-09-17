import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_colors.dart';
import '../utils/social_links.dart';

class _NavItem {
  const _NavItem(this.label, this.path);
  final String label;
  final String path;
}

const List<_NavItem> _navItems = [
  _NavItem('Home', '/'),
  _NavItem('About', '/about'),
  _NavItem('Learn With Me', '/learn-with-me'),
  _NavItem('Contact', '/contact'),
];

/// Persistent site footer shown at the bottom of every page: a
/// "Navigation" column linking every page, plus a "Social Media" column
/// with social links (Instagram, YouTube, Facebook — URLs filled in later
/// via [SocialLinks]).
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final navigation = _FooterColumn(
            heading: 'Navigation',
            children: [
              for (final item in _navItems) _NavLink(item: item),
            ],
          );
          const socialMedia = _FooterColumn(
            heading: 'Social Media',
            children: [
              _SocialLink(label: 'Instagram', url: SocialLinks.instagram),
              _SocialLink(label: 'YouTube', url: SocialLinks.youtube),
              _SocialLink(label: 'Facebook', url: SocialLinks.facebook),
            ],
          );

          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                navigation,
                const SizedBox(height: 20),
                socialMedia,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              navigation,
              const SizedBox(width: 64),
              socialMedia,
            ],
          );
        },
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.heading, required this.children});

  final String heading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          heading,
          style: TextStyle(
            color: AppColors.navText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        for (final child in children) ...[child, const SizedBox(height: 6)],
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item});

  final _NavItem item;

  @override
  Widget build(BuildContext context) {
    return _FooterLink(label: item.label, onTap: () => context.go(item.path));
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink({required this.label, required this.url});

  final String label;
  final String url;

  bool get _isConfigured => url.isNotEmpty;

  Future<void> _open() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FooterLink(
      label: label,
      onTap: _isConfigured ? _open : null,
      dimmed: !_isConfigured,
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap, this.dimmed = false});

  final String label;
  final VoidCallback? onTap;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: dimmed ? AppColors.navText.withValues(alpha: 0.4) : AppColors.navText,
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
