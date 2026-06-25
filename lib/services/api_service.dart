import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class ApiService {
  /// GET data berdasarkan action, contoh: ApiService.getData("getProduct")
  static Future<List<dynamic>> getData(String action) async {
    final url = Uri.parse("${Api.baseUrl}?action=$action");
    final response = await http.get(url);
    final body = jsonDecode(response.body);

    if (body['status'] == true) {
      return body['data'] as List<dynamic>;
    } else {
      throw Exception(body['message'] ?? "Gagal mengambil data");
    }
  }

  /// POST data berdasarkan action, contoh:
  /// ApiService.postData("insertProduct", {"nama": "...", "harga": 1000})
  static Future<Map<String, dynamic>> postData(
      String action, Map<String, dynamic> payload) async {
    final url = Uri.parse(Api.baseUrl);

    final body = {
      "action": action,
      ...payload,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "text/plain"}, // wajib utk Apps Script
      body: jsonEncode(body),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
