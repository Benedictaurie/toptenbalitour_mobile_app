import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String role;
  final String? profilePicture;
  final bool isLoading;
  final String? errorMessage;
  final bool isUnauthorized; // ✅ TAMBAHKAN

  const ProfileState({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.role = 'user',
    this.profilePicture,
    this.isLoading = false,
    this.errorMessage,
    this.isUnauthorized = false, // ✅ TAMBAHKAN
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? role,
    String? profilePicture,
    bool? isLoading,
    String? errorMessage,
    bool? isUnauthorized, // ✅ TAMBAHKAN
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isUnauthorized: isUnauthorized ?? this.isUnauthorized, // ✅ TAMBAHKAN
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phoneNumber,
        address,
        role,
        profilePicture,
        isLoading,
        errorMessage,
        isUnauthorized, // ✅ TAMBAHKAN
      ];
}
