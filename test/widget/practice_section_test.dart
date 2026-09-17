import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/practice_section.dart';

void main() {
  testWidgets('PracticeSection renders the heading', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: PracticeSection())),
      ),
    );

    expect(find.text('Practice'), findsOneWidget);
  });
}
