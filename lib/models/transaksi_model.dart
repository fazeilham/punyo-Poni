class TransaksiModel {
  final String id;
  final String idPesanan;
  final String metode;
  final String status;
  final String tanggal;

  TransaksiModel({
    required this.id,
    required this.idPesanan,
    required this.metode,
    required this.status,
    required this.tanggal,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id']?.toString() ?? "",
      idPesanan: json['idPesanan']?.toString() ?? "",
      metode: json['metode']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      tanggal: json['tanggal']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPesanan": idPesanan,
        "metode": metode,
        "status": status,
        "tanggal": tanggal,
      };
}
