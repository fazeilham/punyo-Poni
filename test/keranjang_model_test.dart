import 'package:flutter_test/flutter_test.dart';
import 'package:uas_projectvoni/models/keranjang_model.dart';

void main() {
  test('KeranjangModel membaca qty dari field qty atau jumlah', () {
    final fromQty = KeranjangModel.fromJson({
      'id_keranjang': '1',
      'id_customer': '10',
      'id_product': '20',
      'qty': 3,
      'subtotal': 45000,
    });

    expect(fromQty.qty, 3);
    expect(fromQty.subtotal, 45000);

    final fromJumlah = KeranjangModel.fromJson({
      'id_keranjang': '2',
      'id_customer': '10',
      'id_product': '21',
      'jumlah': 2,
      'subtotal': 30000,
    });

    expect(fromJumlah.qty, 2);
    expect(fromJumlah.subtotal, 30000);
  });
}
