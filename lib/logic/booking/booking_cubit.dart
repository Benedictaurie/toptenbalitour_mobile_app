import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingInitial());

  // Contoh method fetch booking, bisa disambungkan dengan API atau sumber data lain
  // Future<void> fetchBookings() async {
  //   try {
  //     emit(const BookingLoading());

  //     // Simulasi delay pengambilan data misal dari API atau database
  //     await Future.delayed(const Duration(seconds: 1));

  // Contoh data booking statis, ganti dengan data nyata dari API/db
  final List<Booking> _bookings = [];

  void loadBookings() {
    try {
      emit(const BookingLoading());

      // delay kecil untuk simulasi loading
      Future.delayed(const Duration(milliseconds: 500), () {
        final List<Map<String, dynamic>> jsonBookings = [
          {
            "id": 1,
            "bookingCode": "BK001",
            "customerName": "John Doe",
            "customerPhone": "08123456789",
            "customerEmail": "john@example.com",
            "serviceType": "Paket Tour",
            "participantCount": 4,
            "tourDate": DateTime.now().add(Duration(days: 1)).toIso8601String(),
            "totalPrice": 1500000.0,
            "paymentStatus": "paid",
            "bookingStatus": "confirmed",
            "notes": "Dijemput di depan hotel A",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
          },
          {
            "id": 2,
            "bookingCode": "BK002",
            "customerName": "Putu Ngurah",
            "customerPhone": "08167813780",
            "customerEmail": "ngurah@example.com",
            "serviceType": "Paket Activity",
            "participantCount": 2,
            "tourDate": DateTime.now().add(Duration(days: 2)).toIso8601String(),
            "totalPrice": 750000.0,
            "paymentStatus": "pending",
            "bookingStatus": "confirmed",
            "notes": "",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
          {
            "id": 3,
            "bookingCode": "BK003",
            "customerName": "Salsa Bila",
            "customerPhone": "08793714713",
            "customerEmail": "saossalsa@example.com",
            "serviceType": "Paket Rental",
            "participantCount": 2,
            "tourDate": DateTime.now().add(Duration(days: 2)).toIso8601String(),
            "totalPrice": 120000.0,
            "paymentStatus": "pending",
            "bookingStatus": "completed",
            "notes": "",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
          {
            "id": 4,
            "bookingCode": "BK004",
            "customerName": "Martin Lee",
            "customerPhone": "08190704512",
            "customerEmail": "leemartin@example.com",
            "serviceType": "Paket Activity",
            "participantCount": 5,
            "tourDate": DateTime.now().add(Duration(days: 2)).toIso8601String(),
            "totalPrice": 510000.0,
            "paymentStatus": "paid",
            "bookingStatus": "completed",
            "notes": "",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
          {
            "id": 5,
            "bookingCode": "BK005",
            "customerName": "Lia Liliana",
            "customerPhone": "084037140205",
            "customerEmail": "liliana@example.com",
            "serviceType": "Paket Rental",
            "participantCount": 2,
            "tourDate": DateTime.now().add(Duration(days: 2)).toIso8601String(),
            "totalPrice": 140000.0,
            "paymentStatus": "pending",
            "bookingStatus": "confirmed",
            "notes": "",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
          {
            "id": 6,
            "bookingCode": "BK006",
            "customerName": "Maxi Rome",
            "customerPhone": "084037140215",
            "customerEmail": "rome@example.com",
            "serviceType": "Paket Tour",
            "participantCount": 6,
            "tourDate": DateTime.now().add(Duration(days: 2)).toIso8601String(),
            "totalPrice": 640000.0,
            "paymentStatus": "paid",
            "bookingStatus": "confirmed",
            "notes": "",
            "proofOfPayment": "",
            "verifiedAt": null,
            "createdAt":
                DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
          },
        ];

        _bookings.clear();
        _bookings.addAll(
          jsonBookings.map(
            (json) => Booking(
              id: json['id'] as int,
              bookingCode: json['bookingCode'] as String,
              customerName: json['customerName'] as String,
              customerPhone: json['customerPhone'] as String,
              customerEmail: json['customerEmail'] as String,
              serviceType: json['serviceType'] as String,
              participantCount: json['participantCount'] as int,
              tourDate: DateTime.parse(
                json['tourDate'] as String,
              ), // PARSE ke DateTime
              totalPrice: (json['totalPrice'] as num).toDouble(),
              paymentStatus: json['paymentStatus'] as String,
              bookingStatus: json['bookingStatus'] as String,
              notes: json['notes'] as String?,
              proofOfPayment: json['proofOfPayment'] as String?,
              verifiedAt:
                  json['verifiedAt'] != null
                      ? DateTime.parse(json['verifiedAt'] as String)
                      : null,
              createdAt: DateTime.parse(
                json['createdAt'] as String,
              ), // PARSE ke DateTime
            ),
          ),
        );

        emit(BookingLoaded(List.from(_bookings)));
      });
    } catch (e) {
      emit(BookingError('Failed to load bookings: $e'));
    }
  }

  void refreshBookings() {
    _bookings.clear();
    loadBookings();
  }

  //     emit(BookingLoaded(bookings));
  //   } catch (e) {
  //     emit(BookingError('Failed to load bookings'));
  //   }
  // }
}
