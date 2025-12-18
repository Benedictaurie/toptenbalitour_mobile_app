import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/auth/auth_cubit.dart';
import 'package:toptenbalitour_app/logic/auth/auth_state.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/pages/dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();
  final phoneC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null && !state.isLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.isRegistered == true && !state.isLoading) {
            showOtpPopup(context, emailC.text.trim());
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF2B3264),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.person_add, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              TextField(
                                controller: usernameC,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: emailC,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: passC,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: confirmC,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Konfirmasi Password",
                                  prefixIcon: const Icon(Icons.lock_reset),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: phoneC,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Nomor Telepon",
                                  prefixIcon: const Icon(Icons.phone_android),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              state.isLoading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2B3264,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (passC.text != confirmC.text) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Password tidak cocok",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        context.read<AuthCubit>().register(
                                          usernameC.text.trim(),
                                          emailC.text.trim(),
                                          passC.text.trim(),
                                          phoneC.text.trim(),
                                        );
                                      },
                                      child: const Text(
                                        "Daftar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showOtpPopup(BuildContext context, String email) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: const Color(0xFF2B3264), // background sama
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final otpController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: BlocProvider.value(
            value: context.read<AuthCubit>(),
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.isAuthenticated) {
                  Navigator.pop(context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                    (route) => false,
                  );
                }

                if (state.errorMessage != null && !state.isLoading) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Verifikasi OTP",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // teks jadi putih
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Kode OTP telah dikirim ke email\n$email",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                    ), // teks putih lembut
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: otpController,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Masukkan OTP",
                      labelStyle: const TextStyle(color: Colors.white70),
                      counterText: "",
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    final otp = otpController.text.trim();
                                    if (otp.length != 6) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Masukkan OTP 6 digit"),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<AuthCubit>().verifyEmailOtp(
                                      email,
                                      otp,
                                    );
                                  },
                                  child: const Text(
                                    "Verifikasi OTP",
                                    style: TextStyle(
                                      color: Color(
                                        0xFF2B3264,
                                      ), // warna tulisan tombol
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<AuthCubit>()
                                      .resendVerificationOtp(email);
                                },
                                child: const Text(
                                  "Kirim ulang OTP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
