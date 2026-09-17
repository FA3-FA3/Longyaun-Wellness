import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/founder_section.dart';

void main() {
  testWidgets('FounderSection renders the bio heading and subtitle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: FounderSection())),
      ),
    );

    expect(find.text("Hello! I'm Thomas."), findsOneWidget);
    expect(find.text('Founder of Longyuan (龙元) Wellness'), findsOneWidget);
  });
}
