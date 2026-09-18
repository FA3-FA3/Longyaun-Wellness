import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/pages/contact_page.dart';

void main() {
  Widget buildPage() {
    return const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: ContactPage())),
    );
  }

  testWidgets('ContactPage renders name/email/message fields and a send button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildPage());

    expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Message'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('ContactPage shows validation errors on empty submit without hitting the network', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildPage());

    await tester.tap(find.text('Send Message'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a message'), findsOneWidget);
  });

  testWidgets('ContactPage flags an invalid email address', (WidgetTester tester) async {
    await tester.pumpWidget(buildPage());

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Jane Visitor');
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'not-an-email');
    await tester.enterText(find.widgetWithText(TextFormField, 'Message'), 'Hello there');

    await tester.tap(find.text('Send Message'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
}
