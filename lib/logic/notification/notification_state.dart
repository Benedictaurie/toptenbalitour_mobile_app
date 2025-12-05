class NotificationState {
  final bool isLoading;
  final List<Map<String, dynamic>>? notifications;

  const NotificationState({
    this.isLoading = false,
    this.notifications,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
    );
  }
}
