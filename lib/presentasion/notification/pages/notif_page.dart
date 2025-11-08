import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Contoh data notifikasi statis
  final List<Map<String, String>> notifications = const [
    {
      'title': 'Booking Baru',
      'description': 'Anda menerima booking baru dari Komang Try.',
      'date': '2025-11-03 09:30',
    },
    {
      'title': 'Pembayaran Tertunda',
      'description': 'Booking #B1234 menunggu konfirmasi pembayaran.',
      'date': '2025-11-02 17:45',
    },
    {
      'title': 'Driver Ditugaskan',
      'description': 'Driver I Wayan ditugaskan untuk tour #T5678.',
      'date': '2025-11-01 12:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color(0xFF2B3264),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFF2B3264)),
              title: Text(
                notif['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notif['description']!),
              trailing: Text(
                DateFormat('dd MMM yyyy, HH:mm')
                    .format(DateTime.parse(notif['date']!)),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
