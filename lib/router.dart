import 'package:go_router/go_router.dart';

import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/learn_with_me_page.dart';
import 'widgets/app_shell.dart';

/// No auth guards, no backend redirects — every route is a plain in-memory
/// view. All routes are nested in a ShellRoute so [AppShell] (and its
/// TopNavBar) persists across navigation. Add new top-level pages here.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
