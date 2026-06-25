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
    return PesananModel(
      id: json['id']?.toString() ?? "",
      idCustomer: json['idCustomer']?.toString() ?? "",
      items: json['items']?.toString() ?? "",
      total: num.tryParse(json['total']?.toString() ?? "0") ?? 0,
      status: json['status']?.toString() ?? "",
      tanggal: json['tanggal']?.toString() ?? "",
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
