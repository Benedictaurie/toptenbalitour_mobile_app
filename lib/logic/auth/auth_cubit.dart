import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<void> register(
    String username,
    String email,
    String password,
    String phone,
  ) async {
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
          "phone_number": phone,
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER RAW BODY: ${response.body}");

      // SERVER ERROR 500
      if (response.statusCode >= 500) {
        emit(
          state.copyWith(isLoading: false, errorMessage: "Server Error (500)"),
        );
        return;
      }

      if (response.body.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Response kosong dari server",
          ),
        );
        return;
      }

      // Decode JSON aman
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Format response tidak valid",
          ),
        );
        return;
      }

      print("REGISTER DECODED: $data");

      // BERHASIL
      if (response.statusCode == 201) {
        emit(state.copyWith(isLoading: false, isRegistered: true));
        return;
      }

      // VALIDATION ERROR
      if (response.statusCode == 422) {
        String message = "Registrasi gagal!";
        if (data["errors"] != null) {
          if (data["errors"]["email"] != null) {
            message = "Email sudah terdaftar, gunakan email lain!";
          } else if (data["errors"]["phone_number"] != null) {
            message = "Nomor telepon sudah digunakan!";
          }
        }
        emit(state.copyWith(isLoading: false, errorMessage: message));
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Registrasi gagal!",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: "Terjadi kesalahan: $e"),
      );
    }
  }

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

      print("VERIFY OTP STATUS: ${response.statusCode}");
      print("VERIFY OTP BODY: ${response.body}");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Format response tidak valid",
          ),
        );
        return;
      }

      if (response.statusCode == 200) {
        final token = data["data"]?["access_token"];

        if (token == null) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: "Token tidak ditemukan",
            ),
          );
          return;
        }

        // ✅ SIMPAN TOKEN ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('Token saved after OTP verification: ${token.substring(0, 20)}...');

        emit(
          state.copyWith(isLoading: false, isAuthenticated: true, token: token),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: data["message"] ?? "Verifikasi OTP gagal!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: "Terjadi kesalahan: $e"),
      );
    }
  }

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

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Format response tidak valid",
          ),
        );
        return;
      }

      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: data["message"] ?? "Gagal mengirim ulang OTP!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: "Terjadi kesalahan: $e"),
      );
    }
  }

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

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Format response tidak valid",
          ),
        );
        return;
      }

      if (response.statusCode == 200) {
        final token = data["data"]?["access_token"];

        if (token == null) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: "Token tidak ditemukan",
            ),
          );
          return;
        }

        // ✅ SIMPAN TOKEN ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('Token saved after login: ${token.substring(0, 20)}...');

        emit(
          state.copyWith(isLoading: false, isAuthenticated: true, token: token),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: data["message"] ?? "Login gagal!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: "Terjadi kesalahan: $e"),
      );
    }
  }

  // ✅ UPDATE LOGOUT - Hapus token dari SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('Token removed from storage');
    
    emit(const AuthState(isAuthenticated: false));
  }

  // ✅ TAMBAHAN: Method untuk cek apakah user sudah login
  Future<bool> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      emit(state.copyWith(isAuthenticated: true, token: token));
      return true;
    }
    return false;
  }
}
