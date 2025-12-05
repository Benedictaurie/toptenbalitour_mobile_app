import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingRepository {
  final String baseUrl = "http://10.0.2.2:8000/"; // ganti sesuai API-mu

  Future<List<Booking>> fetchBookings() async {
    final response = await http.get(Uri.parse("$baseUrl/bookings"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data booking: ${response.statusCode}");
    }
  }
}
