import 'package:flutter/foundation.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

abstract class BookingState {
  const BookingState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other.runtimeType == runtimeType;
    // membandingkan tipe objek melalui runtimeType, yaitu dua objek dianggap sama jika dari tipe class yang sama.
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class BookingInitial extends BookingState {
  //Status awal ketika belum ada aksi booking.
  const BookingInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BookingInitial; //membandingkan tipe class
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class BookingLoading extends BookingState {
  //Menandakan proses loading data booking sedang berlangsung.
  const BookingLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is BookingLoading;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class BookingLoaded extends BookingState {
  final List<Booking>
  bookings; //State saat data booking berhasil dimuat, membawa sebuah list bookings

  const BookingLoaded(this.bookings);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookingLoaded) return false;
    return listEquals(
      bookings,
      other.bookings,
    ); //listEquals dipakai untuk membandingkan isi list bookings elemen demi elemen.
  }

  @override
  int get hashCode => bookings.hashCode;
}

class BookingError extends BookingState {
  //Status jika terjadi error saat memuat data booking
  final String message;

  const BookingError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookingError) return false;
    return message == other.message;
  }

  @override
  int get hashCode => message.hashCode;
}
//