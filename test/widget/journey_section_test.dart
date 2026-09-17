import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/journey_section.dart';

void main() {
  testWidgets('JourneySection renders the heading', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: JourneySection())),
      ),
    );

    expect(find.text('My Journey'), findsOneWidget);
  });
}
