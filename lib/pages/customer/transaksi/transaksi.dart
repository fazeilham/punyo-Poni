import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/transaksi_model.dart';
import '../../../models/pesanan_model.dart';
import '../../../models/customer_model.dart';
import '../../../widgets/loading.dart';

class TransaksiPage extends StatefulWidget {
  final CustomerModel? customer;
  const TransaksiPage({super.key, this.customer});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<TransaksiModel> transaksiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  void fetchTransaksi() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("getTransaksi");
      final allTransaksi = data.map((e) => TransaksiModel.fromJson(e)).toList();

      if (widget.customer != null) {
        // fetch pesanan to map which transactions belong to this customer
        final pesananData = await ApiService.getData("getPesanan");
        final pesananList = pesananData
            .map((e) => PesananModel.fromJson(e))
            .where((p) => p.idCustomer == widget.customer!.id_customer)
            .toList();
        final allowedIds = pesananList.map((p) => p.id).toSet();

        setState(() {
          transaksiList = allTransaksi
              .where((t) => allowedIds.contains(t.idPesanan))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          transaksiList = allTransaksi;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi")),
      body: isLoading
          ? const Loading()
          : transaksiList.isEmpty
          ? const Center(child: Text("Belum ada transaksi"))
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
                    subtitle: Text("${t.tanggal}\nMetode: ${t.metode}"),
                    isThreeLine: true,
                    trailing: Text(t.status),
                  ),
                );
              },
            ),
    );
  }
}
