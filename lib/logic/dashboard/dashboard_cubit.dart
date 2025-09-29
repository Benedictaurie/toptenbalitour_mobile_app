import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/dashboard_model.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final BookingCubit bookingCubit; // Inject BookingCubit

  DashboardCubit({required this.bookingCubit}) : super(DashboardInitial());

  void loadDashboardData() async {
    try {
      emit(DashboardLoading());
      // Tunggu sebentar untuk memastikan booking data sudah loaded
      await Future.delayed(Duration(milliseconds: 500));

      // Ambil data dari BookingCubit
      final bookingState = bookingCubit.state;
    
      if (bookingState is BookingLoaded) {
        final allBookings = bookingState.bookings;
      
        // Filter booking untuk hari ini
        final now = DateTime.now();
        final bookingsHariIni = allBookings.where((booking) {
          return booking.tourDate.year == now.year &&
          booking.tourDate.month == now.month &&
          booking.tourDate.day == now.day;
        }).toList();

        // Hitung statistik - PERBAIKAN: ganti @ dengan 0, fix variable name
        final totalPesertaHariIni = bookingsHariIni.fold(
          0, (sum, booking) => sum + booking.participantCount
        );

        // Ambil 3 booking terbaru - PERBAIKAN: pisahkan sort dari method chain
        final bookingTerbaru = allBookings
          .where((booking) => booking.bookingStatus == 'confirmed')
          .toList();
      
        // PERBAIKAN: sort harus dipisah karena tidak return List
        bookingTerbaru.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
        final latestBookings = bookingTerbaru.take(3).toList();

        // Hitung booking perlu konfirmasi - PERBAIKAN: fix field name
        final bookingPerluKonfirmasi = allBookings
          .where((booking) => booking.paymentStatus == 'pending')
          .length;

        final dashboardData = Dashboard(
          totalBookingHariIni: bookingsHariIni.length,
          totalPesertaHariIni: totalPesertaHariIni,
          driverAktifHariIni: 3,
          bookingPerluKonfirmasi: bookingPerluKonfirmasi,
          bookingTerbaru: latestBookings,
          // jadwalDriverHariIni: [
          //   JadwalDriver(
          //     driverName: "Driver A",
          //     tourCode: "Tour Daf-08CO", 
          //     waktuTour: "08:00",
          //     status: "Dijadwalkan",
          //   ),
          // ],
        );

        emit(DashboardLoaded(dashboardData));
      } else {
        emit(DashboardError('Data booking belum tersedia'));
      }
    } catch (e) {
      emit(DashboardError('Gagal memuat data dashboard: $e'));
    }
  }

  // Method untuk refresh data
  void refreshDashboard() {
    loadDashboardData();
  }
}