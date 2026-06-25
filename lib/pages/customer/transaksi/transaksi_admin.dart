import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/transaksi_model.dart';
import '../../../widgets/loading.dart';

class TransaksiAdminPage extends StatefulWidget {
  const TransaksiAdminPage({super.key});

  @override
  State<TransaksiAdminPage> createState() => _TransaksiAdminPageState();
}

class _TransaksiAdminPageState extends State<TransaksiAdminPage> {
  List<TransaksiModel> transaksiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  Future<void> fetchTransaksi() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("getTransaksi");
      setState(() {
        transaksiList = data.map((e) => TransaksiModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat riwayat: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
      ),
      body: isLoading
          ? const Loading()
          : transaksiList.isEmpty
              ? const Center(child: Text("Belum ada riwayat pesanan"))
              : ListView.builder(
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final t = transaksiList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text("Pesanan: ${t.idPesanan}"),
                        subtitle: Text(
                          "Metode: ${t.metode}\nTanggal: ${t.tanggal}\nStatus: ${t.status}",
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}