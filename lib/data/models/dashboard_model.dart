import 'package:toptenbalitour_app/data/models/booking_model.dart';

class Dashboard {
  final int totalBookingHariIni;
  final int totalPesertaHariIni;
  final int driverAktifHariIni;
  final int bookingPerluKonfirmasi;
  final List<Booking> bookingTerbaru;
  //final List<JadwalDriver> jadwalDriverHariIni;//

  Dashboard({
    required this.totalBookingHariIni,
    required this.totalPesertaHariIni,
    required this.driverAktifHariIni,
    required this.bookingPerluKonfirmasi,
    required this.bookingTerbaru,
    // required this.jadwalDriverHariIni,//
  });
}