import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';
import 'package:intl/intl.dart';

class BookingListPage extends StatelessWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada data booking',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return _buildBookingCard(context, booking);
              },
            );
          } else if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Terjadi kesalahan: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<BookingCubit>().loadBookings();
                    },
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B3264),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.cloud_download),
              onPressed: () {
                context.read<BookingCubit>().loadBookings();
              },
              label: const Text('Muat Data Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3264),
                foregroundColor: Colors.white,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2B3264),
        onPressed: () {
          context.read<BookingCubit>().loadBookings();
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  /// --- CARD DESIGN ---
  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ICON kiri
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF2B3264),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),

            // Info booking
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${booking.bookingCode} • ${booking.serviceType}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2B3264),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Nama: ${booking.customerName}'),
                  Text('Peserta: ${booking.participantCount} orang'),
                  Text('Tanggal: ${_formatDate(booking.tourDate)}'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text(
                        'Pembayaran: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        booking.paymentStatus.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              booking.paymentStatus == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol detail
            ElevatedButton(
              onPressed: () => _showBookingDetail(context, booking),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3264),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Detail'),
            ),
          ],
        ),
      ),
    );
  }

  /// --- FORMAT TANGGAL ---
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// --- DIALOG DETAIL ---
  void _showBookingDetail(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Detail Booking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2B3264),
                  ),
                ),
                const SizedBox(height: 16),
                _detailItem('Kode Booking', booking.bookingCode),
                _detailItem('Nama', booking.customerName),
                _detailItem('Email', booking.customerEmail),
                _detailItem('Telepon', booking.customerPhone),
                _detailItem('Layanan', booking.serviceType),
                _detailItem(
                  'Jumlah Peserta',
                  '${booking.participantCount} orang',
                ),
                _detailItem('Tanggal Tour', _formatDate(booking.tourDate)),
                _detailItem('Total Harga', 'Rp ${booking.totalPrice}'),
                _detailItem('Status Pembayaran', booking.paymentStatus),
                _detailItem('Status Booking', booking.bookingStatus),
                if (booking.notes != null && booking.notes!.isNotEmpty)
                  _detailItem('Catatan', booking.notes!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}
