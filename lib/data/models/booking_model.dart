class Booking {
  final String bookingCode;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String serviceType;
  final int participantCount;
  final DateTime tourDate;
  final int totalPrice;
  final String paymentStatus;
  final String bookingStatus;
  final String? notes;
  final DateTime createdAt; // ⬅️ TAMBAHKAN INI

  Booking({
    required this.bookingCode,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.serviceType,
    required this.participantCount,
    required this.tourDate,
    required this.totalPrice,
    required this.paymentStatus,
    required this.bookingStatus,
    this.notes,
    required this.createdAt, // ⬅️ TAMBAHKAN INI
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingCode: json['booking_code'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      serviceType: json['service_type'] ?? '',
      participantCount: json['participant_count'] ?? 0,
      tourDate: DateTime.parse(json['tour_date']),
      totalPrice: json['total_price'] ?? 0,
      paymentStatus: json['payment_status'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']), // ⬅️ PARSE CREATED AT
    );
  }
}
