import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/about_banner.dart';

void main() {
  testWidgets('AboutBanner renders the banner image', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AboutBanner())));

    expect(find.byType(Image), findsOneWidget);
  });
}
