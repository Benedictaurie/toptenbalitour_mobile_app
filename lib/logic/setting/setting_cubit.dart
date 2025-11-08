import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingState.initial());

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));

    // Simulasi pengambilan data (misalnya dari SharedPreferences atau API)
    await Future.delayed(const Duration(milliseconds: 500));

    // Setelah data berhasil dimuat, update state
    emit(state.copyWith(
      isLoading: false,
      isDarkMode: false,
      notificationEnabled: true,
      language: 'Indonesia',
    ));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(isDarkMode: value));
  }

  void toggleNotification(bool value) {
    emit(state.copyWith(notificationEnabled: value));
  }

  void changeLanguage(String lang) {
    emit(state.copyWith(language: lang));
  }
}
