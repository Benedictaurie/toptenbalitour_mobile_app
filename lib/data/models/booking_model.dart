class Booking {
  final int id;
  final String bookingCode;
  final int userId;
  final String bookableType;
  final int bookableId;
  final DateTime startDate;
  final DateTime endDate;
  final int quantity;
  final double unitPriceAtBooking;
  final double totalPrice;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.bookableType,
    required this.bookableId,
    required this.startDate,
    required this.endDate,
    required this.quantity,
    required this.unitPriceAtBooking,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingCode: json['booking_code'],
      userId: json['user_id'],
      bookableType: json['bookable_type'],
      bookableId: json['bookable_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      quantity: json['quantity'],
      unitPriceAtBooking:
          double.parse(json['unit_price_at_booking'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      notes: json['notes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_code': bookingCode,
      'user_id': userId,
      'bookable_type': bookableType,
      'bookable_id': bookableId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'quantity': quantity,
      'unit_price_at_booking': unitPriceAtBooking,
      'total_price': totalPrice,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// ✅ copyWith untuk update field tertentu (misal status)
  Booking copyWith({
    int? id,
    String? bookingCode,
    int? userId,
    String? bookableType,
    int? bookableId,
    DateTime? startDate,
    DateTime? endDate,
    int? quantity,
    double? unitPriceAtBooking,
    double? totalPrice,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      bookingCode: bookingCode ?? this.bookingCode,
      userId: userId ?? this.userId,
      bookableType: bookableType ?? this.bookableType,
      bookableId: bookableId ?? this.bookableId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantity: quantity ?? this.quantity,
      unitPriceAtBooking: unitPriceAtBooking ?? this.unitPriceAtBooking,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Booking(id: $id, bookingCode: $bookingCode, status: $status)';
  }
}
