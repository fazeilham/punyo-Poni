import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/pesanan_model.dart';
import '../../../models/customer_model.dart';
import '../../../widgets/loading.dart';

class PesananPage extends StatefulWidget {
  final CustomerModel customer;
  const PesananPage({super.key, required this.customer});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  List<PesananModel> pesananList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  void fetchPesanan() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.getData("getPesanan");
      final all = data.map((e) => PesananModel.fromJson(e)).toList();
      setState(() {
        pesananList =
            all.where((p) => p.idCustomer == widget.customer.id_customer).toList();
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
      appBar: AppBar(title: const Text("Pesanan Saya")),
      body: isLoading
          ? const Loading()
          : pesananList.isEmpty
              ? const Center(child: Text("Belum ada pesanan"))
              : ListView.builder(
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    final p = pesananList[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(p.items),
                        subtitle: Text("${p.tanggal}\nStatus: ${p.status}"),
                        isThreeLine: true,
                        trailing: Text("Rp ${p.total}"),
                      ),
                    );
                  },
                ),
    );
  }
}
