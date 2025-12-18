import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingRepository {
  final String baseUrl = "http://10.0.2.2:8000/api";

  /// Fetch all bookings (untuk admin)
  Future<List<Booking>> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/admin/admin/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List bookingsData = jsonResponse['data']['bookings'] ?? [];
      return bookingsData.map((e) => Booking.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sesi telah berakhir, silakan login kembali');
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak. Anda tidak memiliki izin admin');
    } else {
      throw Exception('Gagal memuat data booking: ${response.statusCode}');
    }
  }

  /// Fetch bookings with filters (pagination, search, status, etc.)
  Future<Map<String, dynamic>> fetchBookingsWithPagination({
    int page = 1,
    int perPage = 15,
    String? status,
    String? search,
    String? packageType,
    String? dateFrom,
    String? dateTo,
    String? sortBy,
    String? sortOrder,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    final queryParams = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (packageType != null) 'package_type': packageType,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    };

    final uri = Uri.parse('$baseUrl/admin/admin/bookings')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      return {
        'bookings': (data['bookings'] as List)
            .map((e) => Booking.fromJson(e))
            .toList(),
        'pagination': data['pagination'] ?? {},
        'statistics': data['statistics'] ?? {},
      };
    } else if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sesi telah berakhir, silakan login kembali');
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak. Anda tidak memiliki izin admin');
    } else {
      throw Exception('Gagal memuat data booking: ${response.statusCode}');
    }
  }

  /// Fetch single booking detail
  Future<Booking> fetchBookingById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Booking.fromJson(jsonResponse['data']);
    } else if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sesi telah berakhir, silakan login kembali');
    } else if (response.statusCode == 404) {
      throw Exception('Booking tidak ditemukan');
    } else {
      throw Exception('Gagal memuat detail booking: ${response.statusCode}');
    }
  }

  /// Cancel booking
  Future<bool> cancelBooking(int bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) return true;

    if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sesi telah berakhir, silakan login kembali');
    }

    if (response.statusCode == 422) {
      final jsonResponse = jsonDecode(response.body);
      throw Exception(jsonResponse['message'] ?? 'Booking tidak dapat dibatalkan');
    }

    throw Exception('Gagal membatalkan booking');
  }

  /// 🔹 Update booking status (approve / reject)
  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan, silakan login kembali');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/admin/admin/bookings/$bookingId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}), // status = "approved" / "rejected"
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Booking.fromJson(data);
    } else if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sesi telah berakhir, silakan login kembali');
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak. Anda tidak memiliki izin admin');
    } else {
      throw Exception('Gagal mengubah status booking: ${response.body}');
    }
  }
}
