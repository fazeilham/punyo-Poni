import 'package:flutter/material.dart';
import 'product/product_list.dart';
import 'login_admin.dart';

// IMPORT HALAMAN BARU
import '../customer/pesanan/pesanan_admin.dart';
import '../customer/transaksi/transaksi_admin.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  Widget menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF607D8B),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Color(0xFF90A4AE),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget statistikCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: const Color(0xFF1976D2),
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF90CAF9),
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF0D47A1),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginAdmin(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE3F2FD),
                    Color(0xFFBBDEFB),
                    Color(0xFF90CAF9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF1976D2),
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Selamat Datang Admin",
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Kelola data UMKM dengan mudah",
                    style: TextStyle(
                      color: Color(0xFF607D8B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // STATISTIK
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  statistikCard(
                    "Produk",
                    "0",
                    Icons.inventory,
                  ),
                  const SizedBox(width: 10),
                  statistikCard(
                    "Pesanan",
                    "0",
                    Icons.shopping_cart,
                  ),
                  const SizedBox(width: 10),
                  statistikCard(
                    "Transaksi",
                    "0",
                    Icons.payments,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Menu Utama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // KELOLA PRODUK
                  menuCard(
                    icon: Icons.inventory,
                    title: "Kelola Produk",
                    subtitle:
                        "Tambah, edit dan hapus produk",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductListAdmin(),
                        ),
                      );
                    },
                  ),

                  // DATA PESANAN
                  menuCard(
                    icon: Icons.shopping_cart_checkout,
                    title: "Data Pesanan",
                    subtitle:
                        "Lihat pesanan dari customer",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PesananAdminPage(),
                        ),
                      );
                    },
                  ),

                  // RIWAYAT PESANAN
                  menuCard(
                    icon: Icons.receipt_long,
                    title: "Riwayat Pesanan",
                    subtitle:
                        "Lihat riwayat seluruh pesanan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TransaksiAdminPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}