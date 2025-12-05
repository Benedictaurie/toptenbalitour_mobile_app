import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationCubit({required this.notificationRepository})
      : super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Ambil data dari API
      final data = await notificationRepository.fetchNotifications();

      emit(state.copyWith(isLoading: false, notifications: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print("ERROR LOAD NOTIFICATIONS: $e");
    }
  }

  void clearNotifications() {
    emit(state.copyWith(notifications: []));
  }
}
