import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:longyuan_wellness/widgets/app_shell.dart';

void main() {
  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => AppShell(
            currentPath: '/',
            child: SizedBox(
              height: 2000,
              child: Center(child: Text('Page content')),
            ),
          ),
        ),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('header scrolls out of view and footer scrolls into view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());

    final viewportHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final headerFinder = find.text('Longyuan Wellness / 龙源养生');
    final footerFinder = find.text('Social Media');

    // SingleChildScrollView lays out its whole child eagerly, so both
    // exist in the tree from the start — what changes with scrolling is
    // their on-screen position, not their presence.
    expect(tester.getTopLeft(headerFinder).dy, greaterThanOrEqualTo(0));
    expect(tester.getTopLeft(headerFinder).dy, lessThan(viewportHeight));
    expect(tester.getTopLeft(footerFinder).dy, greaterThanOrEqualTo(viewportHeight));

    await tester.dragUntilVisible(
      footerFinder,
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(footerFinder).dy, greaterThanOrEqualTo(0));
    expect(tester.getTopLeft(footerFinder).dy, lessThan(viewportHeight));
    expect(tester.getBottomLeft(headerFinder).dy, lessThanOrEqualTo(0));
  });
}
