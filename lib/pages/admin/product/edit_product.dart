import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController idController;
  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController hargaController;
  late TextEditingController stokController;
  late TextEditingController deskripsiController;
  late TextEditingController gambarController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    idController =
        TextEditingController(text: widget.product.id_product);

    namaController =
        TextEditingController(text: widget.product.nama_product);

    kategoriController =
        TextEditingController(text: widget.product.kategori);

    hargaController =
        TextEditingController(text: widget.product.harga.toString());

    stokController =
        TextEditingController(text: widget.product.stok.toString());

    deskripsiController =
        TextEditingController(text: widget.product.deskripsi);

    gambarController =
        TextEditingController(text: widget.product.gambar);
  }

  void simpan() async {
    setState(() => isLoading = true);

    try {
      final result = await ApiService.postData("updateProduct", {
        "id_product": widget.product.id_product,
        "nama_product": namaController.text.trim(),
        "kategori": kategoriController.text.trim(),
        "harga": num.tryParse(hargaController.text.trim()) ?? 0,
        "stok": num.tryParse(stokController.text.trim()) ?? 0,
        "deskripsi": deskripsiController.text.trim(),
        "gambar": gambarController.text.trim(),
      });

      setState(() => isLoading = false);

      if (result['status'] == true) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Gagal update produk"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CustomTextField(
              controller: idController,
              label: "ID Produk",
              readOnly: true,
            ),

            CustomTextField(
                controller: namaController, label: "Nama Produk"),

            CustomTextField(
                controller: kategoriController, label: "Kategori"),

            CustomTextField(
              controller: hargaController,
              label: "Harga",
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
              controller: stokController,
              label: "Stok",
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
                controller: deskripsiController, label: "Deskripsi"),

            CustomTextField(
                controller: gambarController, label: "URL Gambar"),

            const SizedBox(height: 20),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(text: "Update", onPressed: simpan),
          ],
        ),
      ),
    );
  }
}