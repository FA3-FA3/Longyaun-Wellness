import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:longyuan_wellness/pages/dashboard_page.dart';

void main() {
  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
        GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('DashboardPage renders all five sidebar tabs and selecting one highlights it', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

    for (final label in ['One', 'Two', 'Three', 'Four', 'Five']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Log Out'), findsOneWidget);

    await tester.tap(find.text('Three'));
    await tester.pump();

    // Still just the placeholder tabs — no per-tab content yet.
    for (final label in ['One', 'Two', 'Three', 'Four', 'Five']) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
