import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/data/models/dashboard_model.dart';

class DashboardStatistics extends StatelessWidget {
  final Dashboard summary;

  const DashboardStatistics({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika layar kecil, tampil dua baris
        final isSmallScreen = constraints.maxWidth < 400;

        if (isSmallScreen) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Booking Hari Ini',
                      summary.totalBookingHariIni.toString(),
                      Colors.blue,
                      Icons.list_alt,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Peserta',
                      summary.totalPesertaHariIni.toString(),
                      Colors.green,
                      Icons.people,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildStatCard(
                'Driver Aktif',
                summary.driverAktifHariIni.toString(),
                Colors.orange,
                Icons.directions_car,
              ),
            ],
          );
        }

        // Jika layar cukup lebar → tampil 3 kolom sejajar
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Booking Hari Ini',
                summary.totalBookingHariIni.toString(),
                Colors.blue,
                Icons.list_alt,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Peserta',
                summary.totalPesertaHariIni.toString(),
                Colors.green,
                Icons.people,
              ),
            ),
            const SizedBox(width: 8),
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
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      color: Colors.white, // 🔹 background putih
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Container(
        height: 120, // 🔹 semua card tinggi sama
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // isi di tengah vertikal
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color, // angka tetap pakai warna tema
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
