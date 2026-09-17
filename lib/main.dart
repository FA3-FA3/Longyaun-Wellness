import 'package:flutter/material.dart';

import 'router.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const LongyuanWellnessApp());
}

class LongyuanWellnessApp extends StatelessWidget {
  const LongyuanWellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Longyuan Wellness / 龙源养生',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryLight),
        scaffoldBackgroundColor: AppColors.backgroundLight,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
      ),
      routerConfig: appRouter,
    );
  }
}
