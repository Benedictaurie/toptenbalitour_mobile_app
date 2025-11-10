import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool isLoading;
  final List<Map<String, String>> notifications;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    List<Map<String, String>>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [isLoading, notifications];
}
