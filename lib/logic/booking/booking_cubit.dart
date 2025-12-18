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

      emit(BookingState.loaded(bookings: bookings));
    } catch (e) {
      print('Error loading bookings: $e');

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
      print('Error loading bookings with filters: $e');

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

  // ==================== NEW: Approve / Reject Booking ====================
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status, // 'approved' / 'rejected'
  }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // Panggil repository untuk update status booking
      await repository.updateBookingStatus(bookingId, status);

      // Update local state
      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(status: status);
        }
        return booking;
      }).toList();

      emit(state.copyWith(
        bookings: updatedBookings,
        isLoading: false,
        actionSuccessMessage: status == 'approved'
            ? 'Booking berhasil disetujui'
            : 'Booking berhasil ditolak',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
