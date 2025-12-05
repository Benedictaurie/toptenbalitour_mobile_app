import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationRepository {
  final String baseUrl = "http://10.0.2.2:8000/"; // GANTI sesuai API

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final url = Uri.parse("$baseUrl/notifications");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Sesuaikan dengan struktur API kamu
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      throw Exception("Gagal mengambil notifikasi: ${response.statusCode}");
    }
  }
}
