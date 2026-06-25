import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uas_projectvoni/main.dart';

void main() {
  testWidgets('Test invalid login credentials shows SnackBar error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify we are on the LoginPage.
    expect(find.text('Login UMKM Citra Rasa'), findsOneWidget);

    // Find the TextFields.
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    // Enter wrong credentials.
    await tester.enterText(textFields.at(0), 'wrong_user');
    await tester.enterText(textFields.at(1), 'wrong_pass');

    // Find and tap LOGIN button.
    final loginButton = find.widgetWithText(ElevatedButton, 'LOGIN');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pump(); // Triggers a frame to show SnackBar.

    // Verify that the error snackbar is displayed.
    expect(find.text('Username atau Password Salah'), findsOneWidget);
  });

  testWidgets('Test login with voni/123 and logout works successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the TextFields.
    final textFields = find.byType(TextField);

    // Enter valid voni credentials.
    await tester.enterText(textFields.at(0), 'voni');
    await tester.enterText(textFields.at(1), '123');

    // Find and tap LOGIN button.
    final loginButton = find.widgetWithText(ElevatedButton, 'LOGIN');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for navigation transition.

    // Verify we are on the HomePage.
    expect(find.text('UMKM Citra Rasa'), findsOneWidget);
    expect(find.text('Rendang'), findsOneWidget);

    // Find the logout button.
    final logoutButton = find.byIcon(Icons.logout);
    expect(logoutButton, findsOneWidget);

    // Tap logout.
    await tester.tap(logoutButton);
    await tester.pumpAndSettle(); // Wait for navigation transition.

    // Verify we are back on the LoginPage.
    expect(find.text('Login UMKM Citra Rasa'), findsOneWidget);
  });

  testWidgets('Test login with admin/admin123 and logout works successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the TextFields.
    final textFields = find.byType(TextField);

    // Enter valid admin credentials.
    await tester.enterText(textFields.at(0), 'admin');
    await tester.enterText(textFields.at(1), 'admin123');

    // Find and tap LOGIN button.
    final loginButton = find.widgetWithText(ElevatedButton, 'LOGIN');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for navigation transition.

    // Verify we are on the HomePage.
    expect(find.text('UMKM Citra Rasa'), findsOneWidget);
    expect(find.text('Rendang'), findsOneWidget);

    // Find the logout button.
    final logoutButton = find.byIcon(Icons.logout);
    expect(logoutButton, findsOneWidget);

    // Tap logout.
    await tester.tap(logoutButton);
    await tester.pumpAndSettle(); // Wait for navigation transition.

    // Verify we are back on the LoginPage.
    expect(find.text('Login UMKM Citra Rasa'), findsOneWidget);
  });
}
