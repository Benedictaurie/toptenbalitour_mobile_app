import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';

class DashboardActions extends StatelessWidget {
  const DashboardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BookingListPage()),
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Lihat Semua Booking'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to driver schedule
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => DriverSchedulePage()));
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Lihat Jadwal Driver'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}