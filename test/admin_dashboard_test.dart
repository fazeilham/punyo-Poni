import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uas_projectvoni/pages/admin/dashboard_admin.dart';

void main() {
  testWidgets('Dashboard admin menampilkan menu data pesanan dan riwayat pesanan', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardAdmin()));

    expect(find.text('Data Pesanan'), findsOneWidget);
    expect(find.text('Riwayat Pesanan'), findsOneWidget);
  });
}
