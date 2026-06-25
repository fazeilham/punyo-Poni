class ProductModel {
  final String id_product;
  final String nama_product;
  final String kategori;
  final num harga;
  final num stok;
  final String deskripsi;
  final String gambar;

  ProductModel({
    required this.id_product,
    required this.nama_product,
    required this.kategori,
    required this.harga,
    required this.stok,
    required this.deskripsi,
    required this.gambar,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id_product: json['id_product']?.toString() ?? "",
      nama_product: json['nama_product']?.toString() ?? "",
      kategori: json['kategori']?.toString() ?? "",
      harga: num.tryParse(json['harga']?.toString() ?? "0") ?? 0,
      stok: num.tryParse(json['stok']?.toString() ?? "0") ?? 0,
      deskripsi: json['deskripsi']?.toString() ?? "",
      gambar: json['gambar']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_product": id_product,
      "nama_product": nama_product,
      "kategori": kategori,
      "harga": harga,
      "stok": stok,
      "deskripsi": deskripsi,
      "gambar": gambar,
    };
  }
}