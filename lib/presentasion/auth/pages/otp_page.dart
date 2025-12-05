import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:toptenbalitour_app/logic/auth/auth_cubit.dart';
import 'package:toptenbalitour_app/logic/auth/auth_state.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/pages/dashboard_page.dart';

class OtpPage extends StatelessWidget {
  final String email;

  OtpPage({required this.email, super.key});

  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          // OTP berhasil, navigasi ke dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        }

        if (state.errorMessage != null && !state.isLoading) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Verifikasi OTP")),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Kode OTP telah dikirim ke email Anda",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                keyboardType: TextInputType.number,
                onChanged: (v) {},
              ),
              const SizedBox(height: 20),

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state.isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  final otp = otpController.text.trim();
                                  if (otp.length != 6) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Masukkan OTP 6 digit")));
                                    return;
                                  }

                                  // Panggil verifyEmailOtp dari AuthCubit
                                  context
                                      .read<AuthCubit>()
                                      .verifyEmailOtp(email, otp);
                                },
                                child: const Text("Verifikasi OTP"),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthCubit>()
                                    .resendVerificationOtp(email);
                              },
                              child: const Text("Kirim ulang OTP"),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
