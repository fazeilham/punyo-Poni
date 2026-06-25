import 'package:flutter/material.dart';
import '../../models/customer_model.dart';
import 'product/product_list.dart';
import 'keranjang/keranjang.dart';
import 'pesanan/pesanan.dart';
import 'transaksi/transaksi.dart';
import 'login_customer.dart';

class DashboardCustomer extends StatelessWidget {
  final CustomerModel customer;

  const DashboardCustomer({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFB3E5FC),
        title: const Text(
          "Dashboard Customer",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginCustomer()),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE), Colors.white],
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
                      Icons.person,
                      size: 60,
                      color: Color(0xFF4FC3F7),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Halo, ${customer.nama_customer}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Selamat datang di UMKM Store",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _menuCard(
                    context,
                    title: "Lihat Produk",
                    subtitle: "Jelajahi produk UMKM",
                    icon: Icons.storefront,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductListCustomer(customer: customer),
                        ),
                      );
                    },
                  ),

                  _menuCard(
                    context,
                    title: "Keranjang",
                    subtitle: "Lihat produk yang dipilih",
                    icon: Icons.shopping_cart,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeranjangPage(customer: customer),
                        ),
                      );
                    },
                  ),

                  _menuCard(
                    context,
                    title: "Pesanan Saya",
                    subtitle: "Pantau status pesanan",
                    icon: Icons.receipt_long,
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PesananPage(customer: customer),
                        ),
                      );
                    },
                  ),

                  _menuCard(
                    context,
                    title: "Riwayat Transaksi",
                    subtitle: "Lihat transaksi sebelumnya",
                    icon: Icons.payment,
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TransaksiPage(customer: customer),
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

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}
