class KeranjangModel {
  final String idKeranjang;
  final String idCustomer;
  final String idProduct;
  final num qty;
  final num subtotal;

  KeranjangModel({
    required this.idKeranjang,
    required this.idCustomer,
    required this.idProduct,
    required this.qty,
    required this.subtotal,
  });

  factory KeranjangModel.fromJson(Map<String, dynamic> json) {
    final parsedQty = num.tryParse(json['qty']?.toString() ?? "") ??
        num.tryParse(json['jumlah']?.toString() ?? "") ??
        num.tryParse(json['quantity']?.toString() ?? "") ??
        0;

    final parsedSubtotal = num.tryParse(json['subtotal']?.toString() ?? "") ??
        num.tryParse(json['sub_total']?.toString() ?? "") ??
        0;

    return KeranjangModel(
      idKeranjang: json['id_keranjang']?.toString() ??
          json['idKeranjang']?.toString() ??
          "",
      idCustomer: json['id_customer']?.toString() ??
          json['idCustomer']?.toString() ??
          "",
      idProduct: json['id_product']?.toString() ??
          json['idProduct']?.toString() ??
          "",
      qty: parsedQty,
      subtotal: parsedSubtotal,
    );
  }

  Map<String, dynamic> toJson() => {
        "id_keranjang": idKeranjang,
        "id_customer": idCustomer,
        "id_product": idProduct,
        "qty": qty,
        "subtotal": subtotal,
      };
}