import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(BookingState.initial());

  /// Load all bookings
  Future<void> loadBookings() async {
    emit(BookingState.loading());

    try {
      final bookings = await repository.fetchBookings();

      print('📦 Loaded ${bookings.length} bookings');
      for (var booking in bookings) {
        print('  - ID: ${booking.id}, Code: ${booking.bookingCode}, Status: ${booking.status}');
      }

      emit(BookingState.loaded(bookings: bookings));
    } catch (e) {
      print('❌ Error loading bookings: $e');

      if (e.toString().contains('Sesi telah berakhir') ||
          e.toString().contains('Token tidak ditemukan') ||
          e.toString().contains('401')) {
        emit(BookingState.unauthorized(e.toString()));
      } else {
        emit(BookingState.error(e.toString()));
      }
    }
  }

  /// Load bookings with filters
  Future<void> loadBookingsWithFilters({
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
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await repository.fetchBookingsWithPagination(
        page: page,
        perPage: perPage,
        status: status,
        search: search,
        packageType: packageType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      emit(BookingState.loaded(
        bookings: result['bookings'],
        pagination: result['pagination'],
        statistics: result['statistics'],
      ));
    } catch (e) {
      print('❌ Error loading bookings with filters: $e');

      if (e.toString().contains('Sesi telah berakhir') ||
          e.toString().contains('Token tidak ditemukan') ||
          e.toString().contains('401')) {
        emit(BookingState.unauthorized(e.toString()));
      } else {
        emit(BookingState.error(e.toString()));
      }
    }
  }

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await loadBookings();
  }

  /// Filter by status
  Future<void> filterByStatus(String status) async {
    await loadBookingsWithFilters(status: status);
  }

  /// Search bookings
  Future<void> searchBookings(String query) async {
    await loadBookingsWithFilters(search: query);
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.pagination != null) {
      final currentPage = state.pagination!['current_page'] ?? 1;
      final lastPage = state.pagination!['last_page'] ?? 1;

      if (currentPage < lastPage) {
        await loadBookingsWithFilters(page: currentPage + 1);
      }
    }
  }

  /// Update booking status (approve/reject)
  Future<void> updateBookingStatus({
    required int bookingId,
    required String status,
  }) async {
    try {
      print('═══════════════════════════════════════');
      print('🔹 Cubit updateBookingStatus called');
      print('🔹 Booking ID: $bookingId (${bookingId.runtimeType})');
      print('🔹 Status: $status');
      print('═══════════════════════════════════════');

      emit(state.copyWith(isLoading: true, errorMessage: null));

      final updatedBooking = await repository.updateBookingStatus(
        bookingId,
        status,
      );

      print('✅ Status berhasil diubah ke: ${updatedBooking.status}');

      // Reload dari server untuk sinkronisasi
      await loadBookings();

      emit(state.copyWith(
        isLoading: false,
        actionSuccessMessage: _getSuccessMessage(status),
      ));

    } catch (e) {
      print('❌ Error updating booking status: $e');

      String errorMessage = e.toString();
      
      if (errorMessage.contains('401') || errorMessage.contains('Sesi telah berakhir')) {
        emit(BookingState.unauthorized(errorMessage));
      } else if (errorMessage.contains('404') || errorMessage.contains('tidak ditemukan')) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Booking dengan ID $bookingId tidak ditemukan',
        ));
      } else if (errorMessage.contains('403')) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Anda tidak memiliki izin untuk mengubah status booking',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal mengubah status booking: $errorMessage',
        ));
      }
    }
  }

  /// Helper untuk success message
  String _getSuccessMessage(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Booking berhasil disetujui';
      case 'rejected':
        return 'Booking berhasil ditolak';
      case 'completed':
        return 'Booking berhasil diselesaikan';
      case 'cancelled':
        return 'Booking berhasil dibatalkan';
      default:
        return 'Status booking berhasil diubah';
    }
  }

  /// Shortcut: Approve booking
  Future<void> approveBooking(int bookingId) async {
    await updateBookingStatus(bookingId: bookingId, status: 'confirmed');
  }

  /// Shortcut: Reject booking
  Future<void> rejectBooking(int bookingId) async {
    await updateBookingStatus(bookingId: bookingId, status: 'rejected');
  }

  /// Shortcut: Complete booking
  Future<void> completeBooking(int bookingId) async {
    await updateBookingStatus(bookingId: bookingId, status: 'completed');
  }

  /// Shortcut: Cancel booking
  Future<void> cancelBooking(int bookingId) async {
    await updateBookingStatus(bookingId: bookingId, status: 'cancelled');
  }

  // ✅ HAPUS method getBookingById karena tidak digunakan
  /*
  Future<void> getBookingById(int bookingId) async {
    try {
      emit(state.copyWith(isLoading: true));

      final booking = await repository.fetchBookingById(bookingId);

      emit(state.copyWith(
        isLoading: false,
        selectedBooking: booking, // ❌ Field ini tidak ada di BookingState
      ));
    } catch (e) {
      print('❌ Error getting booking: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
  */

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// Clear success message
  void clearSuccessMessage() {
    emit(state.copyWith(actionSuccessMessage: null));
  }
}
