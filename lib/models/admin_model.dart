class AdminModel {
  final String id;
  final String username;
  final String password;

  AdminModel({
    required this.id,
    required this.username,
    required this.password,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id']?.toString() ?? "",
      username: json['username']?.toString() ?? "",
      password: json['password']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
  };
}
