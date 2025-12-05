import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/dashboard_model.dart';
import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final BookingRepository bookingRepository;

  DashboardCubit({required this.bookingRepository}) : super(DashboardInitial());

  void loadDashboardData() async {
    try {
      emit(DashboardLoading());

      // 🔥 Mengambil data dari API
      final allBookings = await bookingRepository.fetchBookings();

      final now = DateTime.now();

      final bookingsHariIni = allBookings.where((booking) {
        return booking.tourDate.year == now.year &&
            booking.tourDate.month == now.month &&
            booking.tourDate.day == now.day;
      }).toList();

      final totalPesertaHariIni = bookingsHariIni.fold(
        0,
        (sum, booking) => sum + booking.participantCount,
      );

      final bookingTerbaru = allBookings
          .where((booking) => booking.bookingStatus == 'confirmed')
          .toList();

      bookingTerbaru.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final latestBookings = bookingTerbaru.take(3).toList();

      final bookingPerluKonfirmasi = allBookings
          .where((booking) => booking.paymentStatus == 'pending')
          .length;

      final dashboardData = Dashboard(
        totalBookingHariIni: bookingsHariIni.length,
        totalPesertaHariIni: totalPesertaHariIni,
        driverAktifHariIni: 3, // bisa ambil dari API juga
        bookingPerluKonfirmasi: bookingPerluKonfirmasi,
        bookingTerbaru: latestBookings,
      );

      emit(DashboardLoaded(dashboardData));
    } catch (e) {
      emit(DashboardError("Gagal memuat dashboard: $e"));
    }
  }

  void refreshDashboard() {
    loadDashboardData();
  }
}
