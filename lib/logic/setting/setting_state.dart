import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  final bool notificationEnabled;
  final String language;
  final bool isLoading;

  const SettingState({
    this.notificationEnabled = true,
    this.language = 'Indonesia',
    this.isLoading = false,
  });

  SettingState copyWith({
    bool? notificationEnabled,
    String? language,
    bool? isLoading,
  }) {
    return SettingState(
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      language: language ?? this.language,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [notificationEnabled, language, isLoading];
}
