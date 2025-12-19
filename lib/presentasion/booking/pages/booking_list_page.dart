import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';

class BookingListPage extends StatelessWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(BookingRepository())..loadBookings(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state.isUnauthorized) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              });
            }
            if (state.hasError && !state.isUnauthorized) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage ?? 'Terjadi kesalahan'),
                  backgroundColor: Colors.red));
            }
            if (state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.actionSuccessMessage!), 
                  backgroundColor: Colors.green));
            }
          },
          builder: (context, state) {
            if (state.isLoading && !state.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError && !state.hasData) {
              return _buildError(state.errorMessage);
            }
            if (state.isEmpty) return _buildEmpty();

            return RefreshIndicator(
              onRefresh: () => context.read<BookingCubit>().loadBookings(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(context, state.bookings[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final isPending = booking.status.toLowerCase() == 'pending';
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(booking.status), 
                    color: Colors.white, 
                    size: 30
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.bookingCode, 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${booking.id}', // ✅ Tampilkan ID untuk debugging
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text('Peserta: ${booking.quantity} orang'),
                      Text('Mulai: ${_formatDate(booking.startDate)}'),
                      const SizedBox(height: 4),
                      // ✅ Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, 
                          vertical: 4
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.statusLabel,
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ✅ PERBAIKAN: Kirim booking.id (int), bukan booking.bookingCode (String)
                  ElevatedButton.icon(
                    onPressed: () {
                      // ✅ DEBUG: Print sebelum kirim
                      print('🔹 Approve clicked');
                      print('🔹 Booking ID: ${booking.id}');
                      print('🔹 Booking Code: ${booking.bookingCode}');
                      
                      context.read<BookingCubit>().updateBookingStatus(
                        bookingId: booking.id, // ✅ UBAH: Kirim ID (int)
                        status: 'confirmed',
                      );
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // ✅ DEBUG: Print sebelum kirim
                      print('🔹 Reject clicked');
                      print('🔹 Booking ID: ${booking.id}');
                      print('🔹 Booking Code: ${booking.bookingCode}');
                      
                      context.read<BookingCubit>().updateBookingStatus(
                        bookingId: booking.id, // ✅ UBAH: Kirim ID (int)
                        status: 'cancelled', // ✅ UBAH: 'rejected' bukan 'cancelled'
                      );
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Cancell'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, 
                        vertical: 8
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 80, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'Belum ada booking',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _buildError(String? message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          message ?? 'Terjadi kesalahan',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
  }
}
