import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../models/customer_model.dart';
import '../../../widgets/custom_button.dart';
import '../keranjang/keranjang.dart';

class DetailProduct extends StatefulWidget {
  final ProductModel product;
  final CustomerModel customer;

  const DetailProduct({
    super.key,
    required this.product,
    required this.customer,
  });

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int qty = 1;
  bool isLoading = false;
  bool isInCart = false;

  @override
  void initState() {
    super.initState();
    _checkCartStatus();
  }

  Future<void> _checkCartStatus() async {
    try {
      final data = await ApiService.getData("getKeranjang");

      final hasItem = data.any((item) {
        final cartItem = item as Map<String, dynamic>;

        return cartItem['id_customer']?.toString() ==
                widget.customer.id_customer &&
            cartItem['id_product']?.toString() ==
                widget.product.id_product;
      });

      if (mounted) {
        setState(() {
          isInCart = hasItem;
        });
      }
    } catch (_) {}
  }

  Future<void> tambahKeKeranjang() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.postData(
        "insertKeranjang",
        {
          "id_customer": widget.customer.id_customer,
          "id_product": widget.product.id_product,
          "jumlah": qty,
          "subtotal": widget.product.harga * qty,
        },
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (result['status'] == true) {
        if (mounted) {
          setState(() {
            isInCart = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Berhasil ditambahkan ke keranjang",
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ??
                    "Gagal menambah keranjang",
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }
    }
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.image,
            size: 56,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 56,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.nama_product),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProductImage(p.gambar),

          const SizedBox(height: 16),

          Text(
            p.nama_product,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Rp ${p.harga}",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.green,
            ),
          ),

          Text(
            "Stok: ${p.stok}",
          ),

          const SizedBox(height: 8),

          Text(
            p.deskripsi,
          ),

          const SizedBox(height: 16),

          if (isInCart)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Produk ini sudah ada di keranjang",
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
                onPressed: () {
                  if (qty > 1) {
                    setState(() {
                      qty--;
                    });
                  }
                },
              ),

              Text(
                "$qty",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                ),
                onPressed: () {
                  setState(() {
                    qty++;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomButton(
                  text: isInCart
                      ? "Lihat Keranjang"
                      : "Tambah ke Keranjang",
                  color: isInCart
                      ? Colors.orange
                      : null,
                  onPressed: () {
                    if (isInCart) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeranjangPage(
                            customer: widget.customer,
                          ),
                        ),
                      );
                    } else {
                      tambahKeKeranjang();
                    }
                  },
                ),
        ],
      ),
    );
  }
}