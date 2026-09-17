import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/free_resources_section.dart';

void main() {
  testWidgets('FreeResourcesSection renders subtitle, YouTube link, and video preview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: FreeResourcesSection())),
      ),
    );

    expect(find.text('Free Resources'), findsOneWidget);
    expect(find.text('Free Introductory Course'), findsOneWidget);
    expect(find.text('Watch more on YouTube'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
