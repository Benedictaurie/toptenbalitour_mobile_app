import 'booking_model.dart';

class Dashboard {
  final int totalBookingHariIni;
  final int totalPesertaHariIni;
  final int bookingPerluKonfirmasi;
  final List<Booking> bookingTerbaru;
  final int totalBookingBulanIni;
  final double totalRevenueBulanIni;

  Dashboard({
    required this.totalBookingHariIni,
    required this.totalPesertaHariIni,
    required this.bookingPerluKonfirmasi,
    required this.bookingTerbaru,
    required this.totalBookingBulanIni,
    required this.totalRevenueBulanIni,
  });
}
