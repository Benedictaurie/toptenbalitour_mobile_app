import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptenbalitour_app/data/models/profile_model.dart';
import 'package:toptenbalitour_app/utils/exceptions.dart'; // ✅ IMPORT

class ProfileRepository {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<Profile> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null || token.isEmpty) {
      throw UnauthorizedException("Token tidak ditemukan, silakan login kembali");
    }

    print('Fetching profile with token: ${token.substring(0, 20)}...');

    final response = await http.get(
      Uri.parse("$baseUrl/user/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Profile.fromJson(data);
    } else if (response.statusCode == 401) {
      // ✅ CLEAR TOKEN DAN THROW UNAUTHORIZED EXCEPTION
      await prefs.remove('auth_token');
      throw UnauthorizedException("Sesi telah berakhir, silakan login kembali");
    } else if (response.statusCode == 404) {
      throw ApiException("Endpoint tidak ditemukan", 404);
    } else if (response.statusCode == 500) {
      throw ApiException("Server error, coba lagi nanti", 500);
    } else {
      throw ApiException("Gagal memuat profil: ${response.statusCode}", response.statusCode);
    }
  }

  Future<Profile> updateProfile({
    required String name,
    required String phoneNumber,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null || token.isEmpty) {
      throw UnauthorizedException("Token tidak ditemukan, silakan login kembali");
    }

    print('Updating profile...');

    final response = await http.put(
      Uri.parse("$baseUrl/user/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
      }),
    );

    print('Update Status Code: ${response.statusCode}');
    print('Update Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Profile.fromJson(data);
    } else if (response.statusCode == 401) {
      // ✅ CLEAR TOKEN DAN THROW UNAUTHORIZED EXCEPTION
      await prefs.remove('auth_token');
      throw UnauthorizedException("Sesi telah berakhir, silakan login kembali");
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(response.body)['errors'];
      throw ApiException("Validasi gagal: ${errors.toString()}", 422);
    } else {
      throw ApiException("Gagal update profil: ${response.statusCode}", response.statusCode);
    }
  }

  Future<Profile> uploadProfilePicture(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null || token.isEmpty) {
      throw UnauthorizedException("Token tidak ditemukan, silakan login kembali");
    }

    print('Uploading profile picture...');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/user/profile/upload-picture"),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    String fileName = imageFile.path.split('/').last;
    var multipartFile = await http.MultipartFile.fromPath(
      'profile_picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(multipartFile);

    print('Uploading file: $fileName');

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Upload Status Code: ${response.statusCode}');
    print('Upload Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Profile.fromJson(data);
    } else if (response.statusCode == 401) {
      // ✅ CLEAR TOKEN DAN THROW UNAUTHORIZED EXCEPTION
      await prefs.remove('auth_token');
      throw UnauthorizedException("Sesi telah berakhir, silakan login kembali");
    } else if (response.statusCode == 422) {
      final errors = jsonDecode(response.body)['errors'];
      throw ApiException("Validasi gagal: ${errors.toString()}", 422);
    } else {
      throw ApiException("Gagal upload foto: ${response.statusCode}", response.statusCode);
    }
  }
}
