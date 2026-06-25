import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_button.dart';

class TambahProduct extends StatefulWidget {
  const TambahProduct({super.key});

  @override
  State<TambahProduct> createState() => _TambahProductState();
}

class _TambahProductState extends State<TambahProduct> {
  final idProduct = TextEditingController(text: "Menunggu ID dari database...");
  final nama = TextEditingController();
  final kategori = TextEditingController();
  final harga = TextEditingController();
  final stok = TextEditingController();
  final deskripsi = TextEditingController();
  final gambar = TextEditingController();

  bool loading = false;

  void simpan() async {
    setState(() => loading = true);

    try {
      final result = await ApiService.postData("insertProduct", {
        "nama_product": nama.text.trim(),
        "kategori": kategori.text.trim(),
        "harga": harga.text.trim(),
        "stok": stok.text.trim(),
        "deskripsi": deskripsi.text.trim(),
        "gambar": gambar.text.trim(),
      });

      if (!mounted) return;
      setState(() => loading = false);

      if (result['status'] == true) {
        final generatedId = result['id_product'] ??
            (result['data'] is Map ? result['data']['id_product'] : null) ??
            (result['data'] is Map ? result['data']['id'] : null);

        if (generatedId != null) {
          idProduct.text = generatedId.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              generatedId != null
                  ? 'Produk disimpan. ID: $generatedId'
                  : 'Produk disimpan.',
            ),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan produk'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(controller: nama, label: "Nama Produk"),
          CustomTextField(controller: kategori, label: "Kategori"),
          CustomTextField(controller: harga, label: "Harga"),
          CustomTextField(controller: stok, label: "Stok"),
          CustomTextField(controller: deskripsi, label: "Deskripsi"),
          CustomTextField(controller: gambar, label: "URL Gambar"),

          const SizedBox(height: 20),

          loading
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(text: "Simpan", onPressed: simpan),
        ],
      ),
    );
  }
}