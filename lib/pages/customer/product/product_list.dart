import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/product_model.dart';
import '../../../models/customer_model.dart';
import '../../../widgets/loading.dart';
import 'detail_product.dart';

class ProductListCustomer extends StatefulWidget {
  final CustomerModel customer;
  const ProductListCustomer({super.key, required this.customer});

  @override
  State<ProductListCustomer> createState() => _ProductListCustomerState();
}

class _ProductListCustomerState extends State<ProductListCustomer> {
  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("getProduct");
      setState(() {
        products = data.map((e) => ProductModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      body: isLoading
          ? const Loading()
          : products.isEmpty
              ? const Center(child: Text("Belum ada produk"))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.74,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailProduct(
                              product: p,
                              customer: widget.customer,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey.shade100,
                                child: p.gambar.isEmpty
                                    ? const Center(
                                        child: Icon(Icons.image,
                                            size: 40, color: Colors.grey),
                                      )
                                    : Image.network(
                                        p.gambar,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(Icons.broken_image,
                                                size: 40, color: Colors.grey),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.nama_product,
                                      maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text("Rp ${p.harga}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.green)),
                                  const SizedBox(height: 4),
                                  Text("Stok: ${p.stok}",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey.shade600)),
                                ],
                              ),
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
