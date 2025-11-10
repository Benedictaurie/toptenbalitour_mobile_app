import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/setting/setting_cubit.dart';
import 'package:toptenbalitour_app/logic/setting/setting_state.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = SettingCubit();
        cubit.loadSettings(); // aman karena async
        return cubit;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text('Pengaturan'), foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF2B3264),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final cubit = context.read<SettingCubit>();

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SwitchListTile(
                    title: const Text('Notifikasi'),
                    value: state.notificationEnabled,
                    onChanged: cubit.toggleNotification,
                    secondary: const Icon(Icons.notifications_active_outlined),
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Bahasa'),
                    subtitle: Text(state.language),
                    onTap: () async {
                      final newLang = await showDialog<String>(
                        context: context,
                        builder:
                            (_) => SimpleDialog(
                              title: const Text('Pilih Bahasa'),
                              children: [
                                SimpleDialogOption(
                                  child: const Text('Indonesia'),
                                  onPressed:
                                      () => Navigator.pop(context, 'Indonesia'),
                                ),
                                SimpleDialogOption(
                                  child: const Text('English'),
                                  onPressed:
                                      () => Navigator.pop(context, 'English'),
                                ),
                              ],
                            ),
                      );

                      if (newLang != null) {
                        cubit.changeLanguage(newLang);
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
