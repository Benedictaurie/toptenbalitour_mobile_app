import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  /// Simulasi proses login
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    if (email == "admin@gmail.com" && password == "123456") {
      emit(state.copyWith(isLoading: false, isAuthenticated: true));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Email atau password salah!",
      ));
    }
  }

  /// Simulasi proses registrasi
  Future<void> register(String username, String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    // contoh sederhana: validasi email sudah digunakan
    if (email == "admin@gmail.com") {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Email sudah terdaftar!",
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }
}
