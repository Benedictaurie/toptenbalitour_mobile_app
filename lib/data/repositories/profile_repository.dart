import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toptenbalitour_app/data/models/profile_model.dart';

class ProfileRepository {
  final String baseUrl = "http://10.0.2.2:8000/"; // sesuaikan API

  Future<Profile> fetchProfile(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Profile.fromJson(data);
    } else {
      throw Exception("Gagal memuat profil: ${response.statusCode}");
    }
  }
}
