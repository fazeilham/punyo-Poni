import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../widgets/loading.dart';
import 'tambah_product.dart';
import 'edit_product.dart';

class ProductListAdmin extends StatefulWidget {
  const ProductListAdmin({super.key});

  @override
  State<ProductListAdmin> createState() => _ProductListAdminState();
}

class _ProductListAdminState extends State<ProductListAdmin> {
  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService.getData("getProduct");

      setState(() {
        products =
            data.map<ProductModel>((e) => ProductModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> hapusProduct(String id) async {
    try {
      final result = await ApiService.postData(
        "deleteProduct",
        {"id_product": id},
      );

      if (result['status'] == true) {
        if (!mounted) return;
        fetchProducts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Produk berhasil dihapus"),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? "Gagal menghapus produk",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> konfirmasiHapus(ProductModel product) async {
    bool? hapus = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: Text(
          "Yakin ingin menghapus ${product.nama_product}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (hapus == true) {
      hapusProduct(product.id_product);
    }
  }

  Widget buildProductImage(ProductModel product) {
    if (product.gambar.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 30),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        product.gambar,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProducts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahProduct(),
            ),
          );

          fetchProducts();
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Loading()
          : products.isEmpty
              ? const Center(
                  child: Text("Belum ada produk"),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),

                        // GAMBAR PRODUK
                        leading: buildProductImage(p),

                        // NAMA PRODUK
                        title: Text(
                          p.nama_product.isEmpty
                              ? "Nama Produk Kosong"
                              : p.nama_product,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // HARGA DAN STOK
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${p.id_product}"),
                            const SizedBox(height: 4),
                            Text("Rp ${p.harga} • Stok: ${p.stok}"),
                          ],
                        ),

                        // TOMBOL EDIT DAN HAPUS
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditProduct(product: p),
                                  ),
                                );

                                fetchProducts();
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  konfirmasiHapus(p),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}