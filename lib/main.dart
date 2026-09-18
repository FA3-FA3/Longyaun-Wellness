import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'router.dart';
import 'utils/app_colors.dart';

// Real Firebase Auth Emulator by default in debug builds; pass
// --dart-define=USE_EMULATOR=false to point a debug build at real Firebase
// (e.g. for the "live" local stack). Release builds always use real Firebase.
const bool _useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode && _useEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
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
