import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/keranjang_model.dart';
import '../../../models/product_model.dart';
import '../../../models/customer_model.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/custom_button.dart';

class KeranjangItemCard extends StatelessWidget {
  final KeranjangModel item;
  final ProductModel? product;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const KeranjangItemCard({
    super.key,
    required this.item,
    required this.product,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final price = product?.harga ?? 0;
    final total = price * item.qty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood, color: Colors.orange, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.nama_product ?? 'Produk tidak ditemukan',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Rp $price', style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrease,
                        icon: const Icon(Icons.remove_circle_outline),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('${item.qty}', style: const TextStyle(fontSize: 16)),
                      ),
                      IconButton(
                        onPressed: onIncrease,
                        icon: const Icon(Icons.add_circle_outline),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Rp $total', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KeranjangPage extends StatefulWidget {
  final CustomerModel customer;
  const KeranjangPage({super.key, required this.customer});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  bool isLoading = true;
  List<KeranjangModel> keranjangList = [];
  Map<String, ProductModel> productMap = {};
  String selectedPayment = "COD";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final keranjangData = await ApiService.getData("getKeranjang");
      final productData = await ApiService.getData("getProduct");

      final products = productData.map((e) => ProductModel.fromJson(e)).toList();
      final pMap = {for (var p in products) p.id_product: p};

      final keranjang = keranjangData
          .map((e) => KeranjangModel.fromJson(e))
          .where((k) => k.idCustomer == widget.customer.id_customer)
          .toList();

      if (mounted) {
        setState(() {
          keranjangList = keranjang;
          productMap = pMap;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  num get total {
    num t = 0;
    for (var k in keranjangList) {
      final p = productMap[k.idProduct];
      if (p != null) t += p.harga * k.qty;
    }
    return t;
  }

  Future<void> updateQty(String idKeranjang, int newQty) async {
    if (newQty < 1) {
      await removeItem(idKeranjang);
      return;
    }

    try {
      final result = await ApiService.postData("updateKeranjang", {
        "id_keranjang": idKeranjang,
        "qty": newQty,
      });

      if (result['status'] == true) {
        await fetchData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Gagal mengubah jumlah")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<void> removeItem(String idKeranjang) async {
    try {
      final result = await ApiService.postData("deleteKeranjang", {
        "id_keranjang": idKeranjang,
      });

      if (result['status'] == true) {
        await fetchData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Gagal menghapus item")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<void> checkout() async {
    if (keranjangList.isEmpty) return;

    final itemsText = keranjangList.map((k) {
      final p = productMap[k.idProduct];
      return "${p?.nama_product ?? k.idProduct} x${k.qty}";
    }).join(", ");

    try {
      final result = await ApiService.postData("insertPesanan", {
        "id_customer": widget.customer.id_customer,
        "items": itemsText,
        "total": total,
        "status": "Menunggu Konfirmasi",
        "pembayaran": selectedPayment,
        "tanggal": DateTime.now().toIso8601String(),
      });

      if (result['status'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Pesanan berhasil dibuat via $selectedPayment")),
          );
          await Future.wait(keranjangList.map((item) => removeItem(item.idKeranjang)));
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Checkout gagal")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Widget _paymentChip(String label) {
    final isSelected = selectedPayment == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => selectedPayment = label);
      },
      selectedColor: Colors.orange.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange.shade800 : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: isLoading
          ? const Loading()
          : keranjangList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text("Keranjang kosong"),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: keranjangList.length,
                        itemBuilder: (context, index) {
                          final k = keranjangList[index];
                          final p = productMap[k.idProduct];
                          return KeranjangItemCard(
                            item: k,
                            product: p,
                            onIncrease: () => updateQty(k.idKeranjang, (k.qty + 1).toInt()),
                            onDecrease: () => updateQty(k.idKeranjang, (k.qty - 1).toInt()),
                            onRemove: () => removeItem(k.idKeranjang),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Pilih Pembayaran",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _paymentChip("COD"),
                                    _paymentChip("Gopay"),
                                    _paymentChip("OVO"),
                                    _paymentChip("Dana"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total", style: TextStyle(fontSize: 18)),
                              Text("Rp $total",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomButton(text: "Checkout", onPressed: checkout),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
