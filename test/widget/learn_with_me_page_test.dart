import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/pages/learn_with_me_page.dart';

void main() {
  testWidgets('LearnWithMePage renders all three section headings', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: LearnWithMePage())),
      ),
    );

    expect(find.text('Free Resources'), findsOneWidget);
    expect(find.text('Private Lessons'), findsOneWidget);
    expect(find.text('Courses: Structured Online Learning'), findsOneWidget);
  });
}
