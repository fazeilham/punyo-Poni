import 'package:flutter/material.dart';
import 'pages/admin/login_admin.dart';
import 'pages/customer/login_customer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const RoleSelector(),
    );
  }
}

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFE1F5FE),
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 90, color: Color(0xFF1976D2)),

            const SizedBox(height: 15),

            const Text(
              "UMKM Order App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Pilih peran untuk masuk",
              style: TextStyle(color: Color(0xFF546E7A), fontSize: 14),
            ),

            const SizedBox(height: 40),

            // ADMIN CARD
            _buildRoleCard(
              context,
              title: "Admin",
              subtitle: "Kelola produk & pesanan",
              icon: Icons.admin_panel_settings,
              color: Colors.white,
              iconColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginAdmin()),
                );
              },
            ),

            const SizedBox(height: 20),

            // CUSTOMER CARD
            _buildRoleCard(
              context,
              title: "Customer",
              subtitle: "Pesan produk UMKM",
              icon: Icons.shopping_cart,
              color: Colors.white,
              iconColor: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginCustomer()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: iconColor.withOpacity(0.12),
                child: Icon(icon, color: iconColor, size: 30),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF607D8B)),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFF90A4AE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
