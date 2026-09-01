import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app shows login and enters the citizen map', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const OruroDigitalApp());

    expect(find.text('Oruro Digital'), findsOneWidget);
    expect(find.byKey(const ValueKey('emailField')), findsOneWidget);
    expect(find.byKey(const ValueKey('passwordField')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('loginButton')));
    await tester.pumpAndSettle();

    expect(find.text('Mapa inteligente'), findsOneWidget);
    expect(find.byIcon(Icons.map), findsWidgets);
  });
}
