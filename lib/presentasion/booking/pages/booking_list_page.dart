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
                  content: Text(state.actionSuccessMessage!), backgroundColor: Colors.green));
            }
          },
          builder: (context, state) {
            if (state.isLoading && !state.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError && !state.hasData) return _buildError(state.errorMessage);
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
                  child: Icon(_getStatusIcon(booking.status), color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.bookingCode, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Peserta: ${booking.quantity} orang'),
                      Text('Mulai: ${_formatDate(booking.startDate)}'),
                    ],
                  ),
                ),
              ],
            ),
            if (isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingCubit>().updateBookingStatus(
                          bookingId: booking.bookingCode, status: 'confirmed');
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingCubit>().updateBookingStatus(
                          bookingId: booking.bookingCode, status: 'cancelled');
                    },
                    child: const Text('Reject'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() => const Center(child: Text('Belum ada booking'));
  Widget _buildError(String? message) => Center(child: Text(message ?? 'Terjadi kesalahan'));

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
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
  }
}
