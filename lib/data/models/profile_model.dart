class Profile {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String role;
  final String? profilePicture;

  Profile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.role,
    this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',      // Sesuai database
      address: json['address'] ?? '',
      role: json['role'] ?? 'user',
      profilePicture: json['profile_picture'],      // Sesuai database
    );
  }
}
