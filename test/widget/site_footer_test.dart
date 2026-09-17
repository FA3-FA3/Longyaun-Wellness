import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/widgets/site_footer.dart';

void main() {
  testWidgets('SiteFooter renders Navigation and Social Media columns', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SiteFooter())));

    expect(find.text('Navigation'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Learn With Me'), findsOneWidget);

    expect(find.text('Social Media'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);

    expect(find.text('Contact'), findsOneWidget);
  });
}
