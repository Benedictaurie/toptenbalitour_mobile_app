class Booking {
  final int id; 
  final String bookingCode;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String serviceType; //tipe service: 'paket tour', 'paket activity', dan 'paket rental'
  final int participantCount; //jumlah orang
  final DateTime tourDate; //tanggal pelanggan melakukan tour
  final double totalPrice; 
  final String paymentStatus; //'pending', 'paid', 'cancelled'
  final String bookingStatus; // 'confirmed', 'completed', 'cancelled'
  final String? notes; //data didapat dr web
  final String? proofOfPayment; //data image didapat dr web
  final DateTime? verifiedAt; 
  final DateTime createdAt;
  // final DateTime updatedAt;
  
  Booking({
    required this.id, 
    required this.bookingCode, 
    required this.customerName, 
    required this.customerPhone, 
    required this.customerEmail, 
    required this.serviceType, 
    required this.participantCount, 
    required this.tourDate, 
    required this.totalPrice, 
    required this.paymentStatus, 
    required this.bookingStatus, 
    this.notes,
    this.proofOfPayment, 
    this.verifiedAt,
    required this.createdAt,
    // required this.updatedAt,
  });
}