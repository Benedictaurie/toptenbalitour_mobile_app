import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulasi delay (misalnya ambil data dari API)
      await Future.delayed(const Duration(seconds: 1));

      // Data notifikasi contoh
      final data = [
        {
          'title': 'Booking Baru',
          'description': 'Anda menerima booking baru dari Komang Try.',
          'date': '2025-11-03 09:30',
        },
        {
          'title': 'Pembayaran Tertunda',
          'description': 'Booking #B1234 menunggu konfirmasi pembayaran.',
          'date': '2025-11-02 17:45',
        },
        {
          'title': 'Driver Ditugaskan',
          'description': 'Driver I Wayan ditugaskan untuk tour #T5678.',
          'date': '2025-11-01 12:00',
        },
      ];

      emit(state.copyWith(isLoading: false, notifications: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Bisa tambahkan log error kalau mau
      // debugPrint('Error loading notifications: $e');
    }
  }

  void clearNotifications() {
    emit(state.copyWith(notifications: []));
  }
}
