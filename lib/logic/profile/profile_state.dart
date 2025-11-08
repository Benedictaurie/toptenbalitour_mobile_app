import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String imagePath;
  final bool isLoading;

  const ProfileState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.role = '',
    this.imagePath = 'assets/appimages/No_profile_picture.jpg',
    this.isLoading = false,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    String? imagePath,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    address,
    role,
    imagePath,
    isLoading,
  ];
}
