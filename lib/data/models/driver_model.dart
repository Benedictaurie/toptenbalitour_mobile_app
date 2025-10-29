class Driver {
  final int id;
  final String name;
  final String phone;
  final String vehicleType;
  final String licensePlate;
  final String status; //status driver: 'active', 'inactive', 'on-duty'//
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
}
