class CustomerModel {
  final String id_customer;
  final String username;
  final String nama_customer;
  final String email;
  final String password;
  final String telepon;
  final String alamat;

  CustomerModel({
    required this.id_customer,
    required this.username,
    required this.nama_customer,
    required this.email,
    required this.password,
    required this.telepon,
    required this.alamat,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id_customer: json['id_customer']?.toString() ?? "",
      username: json['username']?.toString() ?? "",
      nama_customer: json['nama_customer']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      password: json['password']?.toString() ?? "",
      telepon: json['telepon']?.toString() ?? "",
      alamat: json['alamat']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_customer": id_customer,
      "username": username,
      "nama_customer": nama_customer,
      "email": email,
      "password": password,
      "telepon": telepon,
      "alamat": alamat,
    };
  }
}