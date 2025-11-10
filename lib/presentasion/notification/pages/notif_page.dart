import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toptenbalitour_app/logic/notification/notification_state.dart';
import 'package:toptenbalitour_app/logic/notification/notification_cubit.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = NotificationCubit();
        cubit.loadNotifications();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2B3264),
          centerTitle: true,
          title: const Text(
            'Notifikasi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                context.read<NotificationCubit>().clearNotifications();
              },
            )
          ],
        ),
        backgroundColor: const Color(0xFFF5F6FA),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.notifications.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada notifikasi.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Color(0xFF2B3264),
                    ),
                    title: Text(
                      notif['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notif['description']!),
                    trailing: Text(
                      DateFormat('dd MMM yyyy, HH:mm')
                          .format(DateTime.parse(notif['date']!)),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
