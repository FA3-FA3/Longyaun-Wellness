import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longyuan_wellness/pages/login_page.dart';

void main() {
  testWidgets('LoginPage renders email/password fields and no registration option', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Log In'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Sign-in only — no self-serve registration.
    expect(find.textContaining('Sign up', findRichText: true), findsNothing);
    expect(find.textContaining('Register', findRichText: true), findsNothing);
    expect(find.textContaining('Create account', findRichText: true), findsNothing);
  });
}
