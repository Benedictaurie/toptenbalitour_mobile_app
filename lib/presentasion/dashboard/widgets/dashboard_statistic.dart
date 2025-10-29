import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/data/models/dashboard_model.dart';

class DashboardStatistics extends StatelessWidget {
  final Dashboard summary;

  const DashboardStatistics({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Booking Hari ini',
            summary.totalBookingHariIni.toString(),
            Colors.blue,
            Icons.list_alt,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Peserta',
            summary.totalPesertaHariIni.toString(),
            Colors.green,
            Icons.people,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Driver Aktif',
            summary.driverAktifHariIni.toString(),
            Colors.orange,
            Icons.directions_car,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
//