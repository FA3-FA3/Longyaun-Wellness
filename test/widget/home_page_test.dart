import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/pages/home_page.dart';

void main() {
  testWidgets('HomePage renders the hero headline and CTA', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Longyuan Wellness'), findsOneWidget);
    expect(find.text('Learn with Me'), findsOneWidget);
  });
}
