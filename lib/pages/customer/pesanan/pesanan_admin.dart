import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/pesanan_model.dart';
import '../../../widgets/loading.dart';

class PesananAdminPage extends StatefulWidget {
  const PesananAdminPage({super.key});

  @override
  State<PesananAdminPage> createState() => _PesananAdminPageState();
}

class _PesananAdminPageState extends State<PesananAdminPage> {
  List<PesananModel> pesananList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("getPesanan");
      setState(() {
        pesananList = data.map((e) => PesananModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat pesanan: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Pesanan")),
      body: isLoading
          ? const Loading()
          : pesananList.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : ListView.builder(
              itemCount: pesananList.length,
              itemBuilder: (context, index) {
                final p = pesananList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(p.items),
                    subtitle: Text(
                      "Pelanggan: ${p.idCustomer}\nTanggal: ${p.tanggal}\nStatus: ${p.status}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Rp ${p.total}"),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await _showEditDialog(context, p);
                            } else if (value == 'delete') {
                              await _confirmDelete(context, p);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, PesananModel p) async {
    final itemsCtrl = TextEditingController(text: p.items);
    final totalCtrl = TextEditingController(text: p.total.toString());
    final statusCtrl = TextEditingController(text: p.status);
    final tanggalCtrl = TextEditingController(text: p.tanggal);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Pesanan'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: itemsCtrl,
                decoration: const InputDecoration(labelText: 'Items'),
              ),
              TextField(
                controller: totalCtrl,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusCtrl,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: tanggalCtrl,
                decoration: const InputDecoration(labelText: 'Tanggal'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updatePesanan(
                p.id,
                p.idCustomer,
                itemsCtrl.text.trim(),
                num.tryParse(totalCtrl.text.trim()) ?? p.total,
                statusCtrl.text.trim(),
                tanggalCtrl.text.trim(),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePesanan(
    String id,
    String idCustomer,
    String items,
    num total,
    String status,
    String tanggal,
  ) async {
    try {
      final result = await ApiService.postData('updatePesanan', {
        'id': id,
        'idCustomer': idCustomer,
        'items': items,
        'total': total,
        'status': status,
        'tanggal': tanggal,
      });

      if (result['status'] == true) {
        await fetchPesanan();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan berhasil diupdate')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal update pesanan'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _confirmDelete(BuildContext context, PesananModel p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pesanan'),
        content: const Text('Yakin ingin menghapus pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        final result = await ApiService.postData('deletePesanan', {'id': p.id});
        if (result['status'] == true) {
          await fetchPesanan();
          if (mounted)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Pesanan dihapus')));
        } else {
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['message'] ?? 'Gagal menghapus')),
            );
        }
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
