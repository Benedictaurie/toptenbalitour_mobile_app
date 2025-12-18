import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingTerbaruSection extends StatelessWidget {
  final List<Booking> bookings;

  const BookingTerbaruSection({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Terbaru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.blueAccent,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Jika data kosong
            if (bookings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Tidak ada booking terbaru',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
            else
              Column(
                children: bookings
                    .take(3)
                    .map((booking) =>
                        _buildBookingItem(context, booking))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, Booking booking) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              _getStatusColor(booking.status).withOpacity(0.15),
          child: Icon(
            _getStatusIcon(booking.status),
            color: _getStatusColor(booking.status),
            size: 22,
          ),
        ),
        title: Text(
          booking.bookingCode,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Mulai: ${_formatDate(booking.startDate)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            Text(
              '${booking.quantity} peserta',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),

        // trailing status chip
        trailing: _buildStatusChip(booking.status),
      ),
    );
  }

  // Warna status booking
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blueAccent;
    }
  }

  // Ikon status
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  // Chip status booking (bukan payment)
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        chipColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'pending':
        chipColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'cancelled':
        chipColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      default:
        chipColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 12, color: textColor),
      ),
      backgroundColor: chipColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      visualDensity: VisualDensity.compact,
    );
  }

  // Format tanggal natural
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(date.year, date.month, date.day);

    if (bookingDay == today) {
      return 'Hari ini';
    } else if (bookingDay == today.add(const Duration(days: 1))) {
      return 'Besok';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
