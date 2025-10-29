import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';

class BookingTerbaruSection extends StatelessWidget {
  final List<Booking> bookings;

  const BookingTerbaruSection({super.key, required this.bookings}); //

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Terbaru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingListPage()),
                    );
                  },
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),

            if (bookings.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Tidak ada booking terbaru',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...bookings.map((booking) => _buildBookingItem(booking)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(Booking booking) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(booking.bookingStatus),
        child: Text(
          booking.bookingCode.substring(2, 5),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
      title: Text(
        booking.customerName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${booking.serviceType} - ${_formatTime(booking.tourDate)}'),
          Text(
            '${booking.participantCount} peserta • ${_formatDate(booking.tourDate)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: _buildStatusChip(booking.paymentStatus),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildStatusChip(String paymentStatus) {
    Color chipColor;
    String statusText;

    switch (paymentStatus) {
      case 'paid':
        chipColor = Colors.green[100]!;
        statusText = 'Paid';
        break;
      case 'pending':
        chipColor = Colors.orange[100]!;
        statusText = 'Pending';
        break;
      case 'cancelled':
        chipColor = Colors.red[100]!;
        statusText = 'Cancelled';
        break;
      default:
        chipColor = Colors.grey[100]!;
        statusText = paymentStatus;
    }

    return Chip(
      label: Text(statusText, style: const TextStyle(fontSize: 12)),
      backgroundColor: chipColor,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

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
