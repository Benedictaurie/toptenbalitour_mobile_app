import 'package:equatable/equatable.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingState extends Equatable {
  final List<Booking> bookings;
  final bool isLoading;
  final String? errorMessage;
  final bool isUnauthorized; // ✅ Flag untuk handle 401 error
  final Map<String, dynamic>? pagination; // ✅ Data pagination
  final Map<String, dynamic>? statistics; // ✅ Statistik booking
  final String? actionSuccessMessage; // ✅ Pesan sukses approve/reject

  const BookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isUnauthorized = false,
    this.pagination,
    this.statistics,
    this.actionSuccessMessage, // ✅
  });

  // ✅ Initial state
  factory BookingState.initial() {
    return const BookingState();
  }

  // ✅ Loading state
  factory BookingState.loading() {
    return const BookingState(isLoading: true);
  }

  // ✅ Loaded state
  factory BookingState.loaded({
    required List<Booking> bookings,
    Map<String, dynamic>? pagination,
    Map<String, dynamic>? statistics,
  }) {
    return BookingState(
      bookings: bookings,
      isLoading: false,
      pagination: pagination,
      statistics: statistics,
    );
  }

  // ✅ Error state
  factory BookingState.error(String message) {
    return BookingState(
      isLoading: false,
      errorMessage: message,
    );
  }

  // ✅ Unauthorized state (401)
  factory BookingState.unauthorized(String message) {
    return BookingState(
      isLoading: false,
      errorMessage: message,
      isUnauthorized: true,
    );
  }

  // ✅ Copy with method untuk update state
  BookingState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? errorMessage,
    bool? isUnauthorized,
    Map<String, dynamic>? pagination,
    Map<String, dynamic>? statistics,
    String? actionSuccessMessage, // ✅ Tambahkan di copyWith
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isUnauthorized: isUnauthorized ?? this.isUnauthorized,
      pagination: pagination ?? this.pagination,
      statistics: statistics ?? this.statistics,
      actionSuccessMessage: actionSuccessMessage ?? this.actionSuccessMessage,
    );
  }

  // ✅ Helper getters
  bool get hasError => errorMessage != null;
  bool get hasData => bookings.isNotEmpty;
  bool get isEmpty => bookings.isEmpty && !isLoading;

  @override
  List<Object?> get props => [
        bookings,
        isLoading,
        errorMessage,
        isUnauthorized,
        pagination,
        statistics,
        actionSuccessMessage,
      ];

  @override
  String toString() {
    return 'BookingState(bookings: ${bookings.length}, isLoading: $isLoading, '
        'errorMessage: $errorMessage, isUnauthorized: $isUnauthorized, '
        'actionSuccessMessage: $actionSuccessMessage)';
  }
}
