import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';
import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(const BookingInitial());

  Future<void> loadBookings() async {
    try {
      emit(const BookingLoading());

      final bookings = await repository.fetchBookings();

      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
