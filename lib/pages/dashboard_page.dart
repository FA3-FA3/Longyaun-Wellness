import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

const List<String> _dashboardTabs = ['One', 'Two', 'Three', 'Four', 'Five'];

/// Authenticated dashboard shell: sidebar nav + a workspace area. Tabs and
/// workspace are placeholders — swap in real content per tab as features
/// are built.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedTab = 0;

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final email = Firebase.apps.isEmpty
        ? ''
        : (FirebaseAuth.instance.currentUser?.email ?? '');

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          _TopBar(email: email, onLogOut: _logOut),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Sidebar(
                  selectedIndex: _selectedTab,
                  onSelect: (index) => setState(() => _selectedTab = index),
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.email, required this.onLogOut});

  final String email;
  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      color: AppColors.navBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            'Longyuan Wellness',
            style: TextStyle(
              color: AppColors.navBrand,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (email.isNotEmpty)
            Text(
              email,
              style: TextStyle(color: AppColors.navText, fontSize: 13, fontWeight: FontWeight.w300),
            ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: onLogOut,
            child: Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.navTextActive,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.navBackground,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _dashboardTabs.length; i++)
            _SidebarItem(
              label: _dashboardTabs[i],
              isSelected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: isSelected ? AppColors.navTextActive.withValues(alpha: 0.15) : Colors.transparent,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.navTextActive : AppColors.navText,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
