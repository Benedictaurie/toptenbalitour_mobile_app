import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toptenbalitour_app/data/models/driver_model.dart';

class DriverRepository {
  final String baseUrl = 'https://api.trplweb.wefgis-sync.com/api/drivers';

  Future<List<Driver>> getAllDrivers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Driver.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data driver (${response.statusCode})');
    }
  }
}
