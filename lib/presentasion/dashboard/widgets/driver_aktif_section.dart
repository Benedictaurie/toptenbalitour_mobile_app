import 'package:flutter/material.dart';

class DriverAktifSection extends StatelessWidget {
  const DriverAktifSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Driver Aktif Hari Ini",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3264),
                    ),
                  ),
                  Icon(Icons.local_taxi, color: Color(0xFF2B3264)),
                ],
              ),
              const SizedBox(height: 12),

              // List driver
              _buildDriverCard("Made Surya", "Paket Tour", 3, Colors.orange),
              const Divider(),
              _buildDriverCard("Komang Arta", "Paket Rental", 2, Colors.green),
              const Divider(),
              _buildDriverCard(
                "Nyoman Putra",
                "Airport Transfer",
                1,
                Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(
    String name,
    String service,
    int participants,
    Color color,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: color.withOpacity(0.2),
        child: Icon(Icons.person, color: color, size: 26),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF2B2B2B),
        ),
      ),
      subtitle: Text(
        "$service - $participants Peserta",
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Aktif",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
