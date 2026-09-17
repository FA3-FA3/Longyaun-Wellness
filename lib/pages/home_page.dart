import 'package:flutter/material.dart';

import '../widgets/hero_section.dart';

/// Landing page. State here is in-memory only — it resets on reload, since
/// this app has no backend and no local storage.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeroSection();
  }
}
