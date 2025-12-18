import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/setting/setting_cubit.dart';
import 'package:toptenbalitour_app/logic/setting/setting_state.dart';
import 'package:toptenbalitour_app/utils/string_extensions.dart'; // ✅ IMPORT

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          'settings'.tr(context), // ✅ GUNAKAN TRANSLATION
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2B3264),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final cubit = context.read<SettingCubit>();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Notifikasi
                  Text(
                    'notification'.tr(context), // ✅ TRANSLATION
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: Text('activate_notification'.tr(context)), // ✅
                      subtitle: Text(
                        state.notificationEnabled
                            ? 'notification_enabled'.tr(context) // ✅
                            : 'notification_disabled'.tr(context), // ✅
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      value: state.notificationEnabled,
                      onChanged: (value) {
                        cubit.toggleNotification(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? 'notification_enabled'.tr(context) // ✅
                                  : 'notification_disabled'.tr(context), // ✅
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: state.notificationEnabled
                              ? const Color(0xFF2B3264).withOpacity(0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          state.notificationEnabled
                              ? Icons.notifications_active
                              : Icons.notifications_off,
                          color: state.notificationEnabled
                              ? const Color(0xFF2B3264)
                              : Colors.grey,
                        ),
                      ),
                      activeColor: const Color(0xFF2B3264),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Section: Bahasa
                  Text(
                    'language_region'.tr(context), // ✅
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3264).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.language,
                          color: Color(0xFF2B3264),
                        ),
                      ),
                      title: Text('app_language'.tr(context)), // ✅
                      subtitle: Text(
                        state.language,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final newLang = await showDialog<String>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('choose_language'.tr(context)), // ✅
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<String>(
                                  title: const Text('Indonesia'),
                                  value: 'Indonesia',
                                  groupValue: state.language,
                                  onChanged: (value) {
                                    if (value != null) {
                                      Navigator.pop(context, value);
                                    }
                                  },
                                  activeColor: const Color(0xFF2B3264),
                                ),
                                RadioListTile<String>(
                                  title: const Text('English'),
                                  value: 'English',
                                  groupValue: state.language,
                                  onChanged: (value) {
                                    if (value != null) {
                                      Navigator.pop(context, value);
                                    }
                                  },
                                  activeColor: const Color(0xFF2B3264),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('cancel'.tr(context)), // ✅
                              ),
                            ],
                          ),
                        );

                        if (newLang != null && newLang != state.language) {
                          cubit.changeLanguage(newLang);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${'language_changed'.tr(context)} $newLang', // ✅
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Section: Lainnya
                  Text(
                    'others'.tr(context), // ✅
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text('about_app'.tr(context)), // ✅
                          subtitle: Text('${'version'.tr(context)} 1.0.0'), // ✅
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('about_app'.tr(context)), // ✅
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'app_name'.tr(context), // ✅
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('${'version'.tr(context)}: 1.0.0'), // ✅
                                    const SizedBox(height: 4),
                                    const Text('Build: 2025.12.18'),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.language == 'English'
                                          ? 'App for booking tours and rentals in Bali.'
                                          : 'Aplikasi untuk booking tour dan rental di Bali.',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('close'.tr(context)), // ✅
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.restore,
                              color: Colors.orange,
                            ),
                          ),
                          title: Text('reset_settings'.tr(context)), // ✅
                          subtitle: Text('reset_to_default'.tr(context)), // ✅
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('reset_settings'.tr(context)), // ✅
                                content: Text('reset_confirm'.tr(context)), // ✅
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('cancel'.tr(context)), // ✅
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      cubit.resetSettings();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('settings_reset'.tr(context)), // ✅
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
