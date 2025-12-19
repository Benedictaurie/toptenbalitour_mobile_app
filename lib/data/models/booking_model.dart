class Booking {
  final int id;
  final String bookingCode;
  final int userId;
  final String bookableType;
  final int bookableId;
  final DateTime startDate;
  final DateTime? endDate;
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
    this.endDate,
    required this.quantity,
    required this.unitPriceAtBooking,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ fromJson dengan error handling
  factory Booking.fromJson(Map<String, dynamic> json) {
    try {
      return Booking(
        id: json['id'] as int? ?? 0,
        bookingCode: json['booking_code'] as String? ?? '',
        userId: json['user_id'] as int? ?? 0,
        bookableType: json['bookable_type'] as String? ?? '',
        bookableId: json['bookable_id'] as int? ?? 0,
        
        startDate: _parseDateTime(json['start_date']) ?? DateTime.now(),
        endDate: _parseDateTime(json['end_date']),
        
        quantity: json['quantity'] as int? ?? 1,
        unitPriceAtBooking: _parseDouble(json['unit_price_at_booking']),
        totalPrice: _parseDouble(json['total_price']),
        notes: json['notes'] as String?,
        status: json['status'] as String? ?? 'pending',
        
        createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
        updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
      );
    } catch (e) {
      print('❌ Error parsing Booking: $e');
      print('📦 JSON data: $json');
      rethrow;
    }
  }

  /// ✅ Helper method untuk parsing DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is DateTime) {
        return value;
      }
      return null;
    } catch (e) {
      print('⚠️ Error parsing DateTime: $value - $e');
      return null;
    }
  }

  /// ✅ Helper method untuk parsing double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_code': bookingCode,
      'user_id': userId,
      'bookable_type': bookableType,
      'bookable_id': bookableId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'quantity': quantity,
      'unit_price_at_booking': unitPriceAtBooking,
      'total_price': totalPrice,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// ✅ copyWith
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

  // ==================== HELPER GETTERS (Pure Dart) ====================

  /// Status label Indonesia
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      case 'rejected':
        return 'Ditolak';
      case 'pending':
      default:
        return 'Menunggu';
    }
  }

  /// Package type label
  String get packageTypeLabel {
    final type = bookableType.toLowerCase();
    if (type.contains('tour')) return 'Tour';
    if (type.contains('activity')) return 'Activity';
    if (type.contains('rental')) return 'Rental';
    return 'Unknown';
  }

  /// Format tanggal Indonesia
  String get formattedStartDate {
    return '${startDate.day} ${_getMonthName(startDate.month)} ${startDate.year}';
  }

  String? get formattedEndDate {
    if (endDate == null) return null;
    return '${endDate!.day} ${_getMonthName(endDate!.month)} ${endDate!.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  /// Format harga Rupiah
  String get formattedTotalPrice {
    return 'Rp ${_formatCurrency(totalPrice)}';
  }

  String get formattedUnitPrice {
    return 'Rp ${_formatCurrency(unitPriceAtBooking)}';
  }

  String _formatCurrency(double amount) {
    final str = amount.toStringAsFixed(0);
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Boolean checks
  bool get canBeCancelled => status.toLowerCase() == 'pending';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isRejected => status.toLowerCase() == 'rejected';
  
  bool get isActive => ['pending', 'confirmed'].contains(status.toLowerCase());

  /// Durasi booking dalam hari
  int? get durationInDays {
    if (endDate == null) return null;
    return endDate!.difference(startDate).inDays + 1;
  }

  /// Range tanggal dalam format string
  String get dateRangeString {
    if (endDate == null) return formattedStartDate;
    return '$formattedStartDate - $formattedEndDate';
  }

  @override
  String toString() {
    return 'Booking(id: $id, code: $bookingCode, status: $status, type: $packageTypeLabel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
