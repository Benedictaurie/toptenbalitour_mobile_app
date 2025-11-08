class SettingState {
  final bool isLoading;
  final bool isDarkMode;
  final bool notificationEnabled;
  final String language;

  SettingState({
    required this.isLoading,
    required this.isDarkMode,
    required this.notificationEnabled,
    required this.language,
  });

  factory SettingState.initial() => SettingState(
        isLoading: false,
        isDarkMode: false,
        notificationEnabled: true,
        language: 'Indonesia',
      );

  SettingState copyWith({
    bool? isLoading,
    bool? isDarkMode,
    bool? notificationEnabled,
    String? language,
  }) {
    return SettingState(
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      language: language ?? this.language,
    );
  }
}
