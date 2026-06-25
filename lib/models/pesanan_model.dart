class PesananModel {
  final String id;
  final String idCustomer;
  final String items;
  final num total;
  final String status;
  final String tanggal;

  PesananModel({
    required this.id,
    required this.idCustomer,
    required this.items,
    required this.total,
    required this.status,
    required this.tanggal,
  });

  factory PesananModel.fromJson(Map<String, dynamic> json) {
    String tryKeys(List<String> keys) {
      for (var k in keys) {
        if (json.containsKey(k) && json[k] != null) return json[k].toString();
      }
      return '';
    }

    final idStr = tryKeys(['id', 'idPesanan', 'id_pesanan', 'id_order', 'id']);
    final idCustomerStr = tryKeys([
      'idCustomer',
      'id_customer',
      'customer_id',
      'idCustomer',
    ]);
    final itemsStr = tryKeys(['items', 'item', 'produk', 'products']);
    final totalStr = tryKeys(['total', 'amount', 'harga_total', 'grand_total']);
    final statusStr = tryKeys(['status', 'order_status']);
    final tanggalStr = tryKeys(['tanggal', 'date', 'created_at', 'waktu']);

    return PesananModel(
      id: idStr,
      idCustomer: idCustomerStr,
      items: itemsStr,
      total: num.tryParse(totalStr.isEmpty ? '0' : totalStr) ?? 0,
      status: statusStr,
      tanggal: tanggalStr,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "idCustomer": idCustomer,
    "items": items,
    "total": total,
    "status": status,
    "tanggal": tanggal,
  };
}
