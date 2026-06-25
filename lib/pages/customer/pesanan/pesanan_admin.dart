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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat pesanan: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pesanan"),
      ),
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
                        trailing: Text("Rp ${p.total}"),
                      ),
                    );
                  },
                ),
    );
  }
}