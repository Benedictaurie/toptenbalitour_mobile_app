import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(const SettingState());

  // Keys untuk SharedPreferences
  static const String _notificationKey = 'notification_enabled';
  static const String _languageKey = 'language';

  /// Load settings dari SharedPreferences
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      
      final notificationEnabled = prefs.getBool(_notificationKey) ?? true;
      final language = prefs.getString(_languageKey) ?? 'Indonesia';

      print('Settings loaded: Notification=$notificationEnabled, Language=$language');

      emit(state.copyWith(
        notificationEnabled: notificationEnabled,
        language: language,
        isLoading: false,
      ));
    } catch (e) {
      print('Error loading settings: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Toggle notifikasi
  Future<void> toggleNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationKey, value);
      
      print('Notification toggled: $value');

      emit(state.copyWith(notificationEnabled: value));
    } catch (e) {
      print('Error toggling notification: $e');
    }
  }

  /// Ganti bahasa
  Future<void> changeLanguage(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
      
      print('Language changed: $language');

      emit(state.copyWith(language: language));
    } catch (e) {
      print('Error changing language: $e');
    }
  }

  /// Reset settings ke default
  Future<void> resetSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationKey);
      await prefs.remove(_languageKey);
      
      print('Settings reset to default');

      emit(const SettingState(
        notificationEnabled: true,
        language: 'Indonesia',
        isLoading: false,
      ));
    } catch (e) {
      print('Error resetting settings: $e');
    }
  }
}
