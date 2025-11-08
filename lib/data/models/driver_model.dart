class Driver {
  final int id;
  final String name;
  final String phone;
  final String vehicleType;
  final String licensePlate;
  final String status; // 'active', 'inactive', 'on-duty'
  final DateTime? lastActive;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.licensePlate,
    required this.status,
    this.lastActive,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      status: json['status'] ?? 'inactive',
      lastActive:
          json['lastActive'] != null
              ? DateTime.tryParse(json['lastActive'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'licensePlate': licensePlate,
      'status': status,
      'lastActive': lastActive?.toIso8601String(),
    };
  }
}
