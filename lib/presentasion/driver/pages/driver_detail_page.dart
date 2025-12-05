import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/data/models/driver_model.dart';

class DriverDetailPage extends StatelessWidget {
  final Driver driver;
  const DriverDetailPage({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar Driver
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, color: Colors.blue, size: 60),
            ),
            const SizedBox(height: 16),

            Text(
              driver.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B3264),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Status: ${driver.status}",
              style: TextStyle(
                color: driver.status == 'active'
                    ? Colors.green
                    : (driver.status == 'on-duty'
                        ? Colors.orange
                        : Colors.grey),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Detail Informasi
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.phone, "Nomor Telepon", driver.phone),
                    _buildDetailRow(Icons.directions_car, "Jenis Kendaraan", driver.vehicleType),
                    _buildDetailRow(Icons.confirmation_number, "Nomor Plat", driver.licensePlate),
                    _buildDetailRow(Icons.schedule, "Status", driver.status),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Tombol WhatsApp (UI Saja)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Belum berfungsi — nanti bisa ditambahkan launch URL
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  "Hubungi via WhatsApp",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2B3264)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
