import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/home_page.dart';
import 'pages/learn_with_me_page.dart';
import 'pages/login_page.dart';
import 'utils/auth_notifier.dart';
import 'widgets/app_shell.dart';

/// Public site routes have no auth guards. `/login` and `/dashboard` sit
/// outside the public ShellRoute (and its AppShell/TopNavBar) as top-level
/// routes, gated by [redirect]: signed-out visitors are bounced off
/// `/dashboard` to `/login`, and signed-in users are bounced off `/login`
/// straight to `/dashboard`.
///
/// `/login` and `/dashboard` use [NoTransitionPage] rather than the default
/// route transition — ShellRoute's nested Navigator combined with AppShell's
/// unbounded SingleChildScrollView can overflow mid-transition otherwise.
final AuthNotifier authNotifier = AuthNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final loggedIn = Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;
    final onLogin = state.matchedLocation == '/login';
    final onDashboard = state.matchedLocation.startsWith('/dashboard');
    if (!loggedIn && onDashboard) return '/login';
    if (loggedIn && onLogin) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const NoTransitionPage(child: LoginPage()),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => const NoTransitionPage(child: DashboardPage()),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(currentPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
        GoRoute(path: '/learn-with-me', builder: (context, state) => const LearnWithMePage()),
        GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
      ],
    ),
  ],
);
