import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final String baseUrl = "http://10.0.2.2:8000/api";

  /// REGISTER
  Future<void> register(String username, String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": username,
          "email": email,
          "password": password,
          "password_confirmation": password,
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registrasi sukses, tapi belum authenticated karena harus OTP
        emit(state.copyWith(isLoading: false, isRegistered: true));
      } else {
        emit(state.copyWith(
            isLoading: false, errorMessage: data["message"] ?? "Registrasi gagal!"));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Terjadi kesalahan: $e"));
    }
  }

  /// VERIFY EMAIL OTP
  Future<void> verifyEmailOtp(String email, String otp) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-email"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email, "otp": otp}),
      );

      print("VERIFY EMAIL OTP STATUS: ${response.statusCode}");
      print("VERIFY EMAIL OTP BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // OTP valid, user authenticated
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          token: data["token"],
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Verifikasi OTP gagal!",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Terjadi kesalahan: $e"));
    }
  }

  /// RESEND OTP
  Future<void> resendVerificationOtp(String email) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/resend-verification-otp"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email}),
      );

      print("RESEND OTP STATUS: ${response.statusCode}");
      print("RESEND OTP BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Gagal mengirim ulang OTP!",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Terjadi kesalahan: $e"));
    }
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          token: data["token"],
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Login gagal!",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Terjadi kesalahan: $e"));
    }
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }
}
