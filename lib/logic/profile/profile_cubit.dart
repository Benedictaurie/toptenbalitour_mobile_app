import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  /// Simulasi mengambil data profil (misalnya dari API)
  void loadProfile() {
    emit(state.copyWith(isLoading: true));
    Future.delayed(const Duration(milliseconds: 800), () {
      emit(state.copyWith(
        name: "Admin",
        email: "admin@example.com",
        phone: "+62 812 3456 7890",
        address: "Denpasar, Bali",
        role: "Administrator",
        isLoading: false,
      ));
    });
  }

  /// Contoh fungsi update profil
  void updateName(String newName) {
    emit(state.copyWith(name: newName));
  }

  /// Contoh fungsi logout
  void logout() {
    // bisa tambahkan logika clear data di sini
    emit(const ProfileState());
  }
}
