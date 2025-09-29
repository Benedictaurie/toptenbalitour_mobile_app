import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/models/booking_model.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/booking/booking_state.dart';

class BookingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Booking'),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          print('Current state: $state'); // Debugging
          
          if (state is BookingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BookingLoaded) {
            if (state.bookings.isEmpty) {
              return Center(child: Text('Tidak ada data booking'));
            }
            
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return Card(
                  color: const Color.fromARGB(255, 218, 218, 218),
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      '${booking.bookingCode} - ${booking.serviceType}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Nama: ${booking.customerName}'),
                        Text('Peserta: ${booking.participantCount} orang'),
                        Text('Tanggal: ${_formatDate(booking.tourDate)}'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Status Pembayaran: ', 
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              booking.paymentStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: booking.paymentStatus == 'paid' 
                                    ? Colors.green 
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke detail booking
                        _showBookingDetail(context, booking);
                      },
                      child: Text('Detail'),
                    ),
                  ),
                );
              },
            );
          } else if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingCubit>().loadBookings();
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          
          // State awal atau tidak dikenali
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<BookingCubit>().loadBookings();
              },
              child: Text('Load Bookings'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<BookingCubit>().loadBookings();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showBookingDetail(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Booking'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kode: ${booking.bookingCode}'),
              Text('Nama: ${booking.customerName}'),
              Text('Email: ${booking.customerEmail}'),
              Text('Telepon: ${booking.customerPhone}'),
              Text('Layanan: ${booking.serviceType}'),
              Text('Jumlah Peserta: ${booking.participantCount}'),
              Text('Tanggal Tour: ${_formatDate(booking.tourDate)}'),
              Text('Total Harga: Rp ${booking.totalPrice}'),
              Text('Status Pembayaran: ${booking.paymentStatus}'),
              Text('Status Booking: ${booking.bookingStatus}'),
              if (booking.notes != null && booking.notes!.isNotEmpty)
                Text('Catatan: ${booking.notes}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}