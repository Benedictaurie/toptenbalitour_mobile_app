import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/dashboard_model.dart';
import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final BookingRepository bookingRepository;

  DashboardCubit({required this.bookingRepository})
      : super(DashboardInitial());

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());

      final allBookings = await bookingRepository.fetchBookings();
      final now = DateTime.now();

      /// 🔵 1. Booking Hari Ini
      final bookingsHariIni = allBookings.where((booking) =>
          booking.startDate.year == now.year &&
          booking.startDate.month == now.month &&
          booking.startDate.day == now.day).toList();

      /// 🔵 2. Total peserta hari ini
      final totalPesertaHariIni =
          bookingsHariIni.fold(0, (sum, b) => sum + b.quantity);

      /// 🔵 3. Booking terbaru (confirmed, limit 5)
      final latestBookings = allBookings
          .where((b) => b.status == 'confirmed')
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      /// 🔵 4. Booking perlu konfirmasi (pending)
      final bookingPerluKonfirmasi =
          allBookings.where((b) => b.status == 'pending').length;

      /// 🔵 5. Statistik bulan ini
      final totalBookingBulanIni = allBookings.where((b) =>
          b.createdAt.year == now.year &&
          b.createdAt.month == now.month).length;

      final totalRevenueBulanIni = allBookings
          .where((b) =>
              b.createdAt.year == now.year &&
              b.createdAt.month == now.month &&
              (b.status == 'confirmed' || b.status == 'completed'))
          .fold(0.0, (sum, b) => sum + b.totalPrice);

      /// 🔵 6. Emit dashboard data
      emit(DashboardLoaded(
        Dashboard(
          totalBookingHariIni: bookingsHariIni.length,
          totalPesertaHariIni: totalPesertaHariIni,
          bookingPerluKonfirmasi: bookingPerluKonfirmasi,
          bookingTerbaru: latestBookings.take(5).toList(),
          totalBookingBulanIni: totalBookingBulanIni,
          totalRevenueBulanIni: totalRevenueBulanIni,
        ),
      ));
    } on Exception catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('401') ||
          errorMessage.contains('Token') ||
          errorMessage.contains('Sesi telah berakhir')) {
        emit(DashboardUnauthorized(errorMessage));
      } else {
        emit(DashboardError("Gagal memuat dashboard: $errorMessage"));
      }
    } catch (e) {
      emit(DashboardError("Gagal memuat dashboard: $e"));
    }
  }

  /// Refresh dashboard
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  /// Statistik saja
  Future<Map<String, dynamic>?> getStatistics() async {
    try {
      final result = await bookingRepository.fetchBookingsWithPagination(
        perPage: 100,
      );
      return result['statistics'];
    } catch (_) {
      return null;
    }
  }
}
