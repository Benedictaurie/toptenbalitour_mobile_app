import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toptenbalitour_app/data/models/driver_model.dart';

class DriverRepository {
  final String baseUrl = "http://10.0.2.2:8000/"; // ganti sesuai API kamu

  Future<List<Driver>> getDrivers() async {
    final response = await http.get(Uri.parse("$baseUrl/drivers"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((json) => Driver.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data driver: ${response.statusCode}");
    }
  }
}
