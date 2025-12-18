import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import 'package:toptenbalitour_app/data/repositories/profile_repository.dart';
import 'package:toptenbalitour_app/utils/exceptions.dart'; // ✅ IMPORT

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isUnauthorized: false));
    
    try {
      final profile = await repository.fetchProfile();

      emit(
        state.copyWith(
          name: profile.name,
          email: profile.email,
          phoneNumber: profile.phoneNumber,
          address: profile.address,
          role: profile.role,
          profilePicture: profile.profilePicture ?? state.profilePicture,
          isLoading: false,
          errorMessage: null,
          isUnauthorized: false,
        ),
      );
    } on UnauthorizedException catch (e) {
      // ✅ HANDLE UNAUTHORIZED
      print('Unauthorized error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: true, // ✅ SET FLAG
        ),
      );
    } catch (e) {
      print('Error loading profile: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: false,
        ),
      );
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phoneNumber,
    required String address,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isUnauthorized: false));
    
    try {
      final updatedProfile = await repository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
      );

      emit(
        state.copyWith(
          name: updatedProfile.name,
          email: updatedProfile.email,
          phoneNumber: updatedProfile.phoneNumber,
          address: updatedProfile.address,
          role: updatedProfile.role,
          profilePicture: updatedProfile.profilePicture ?? state.profilePicture,
          isLoading: false,
          errorMessage: null,
          isUnauthorized: false,
        ),
      );
      
      return true;
    } on UnauthorizedException catch (e) {
      // ✅ HANDLE UNAUTHORIZED
      print('Unauthorized error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: true, // ✅ SET FLAG
        ),
      );
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: false,
        ),
      );
      return false;
    }
  }

  Future<bool> uploadProfilePicture(File imageFile) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isUnauthorized: false));
    
    try {
      final updatedProfile = await repository.uploadProfilePicture(imageFile);

      emit(
        state.copyWith(
          name: updatedProfile.name,
          email: updatedProfile.email,
          phoneNumber: updatedProfile.phoneNumber,
          address: updatedProfile.address,
          role: updatedProfile.role,
          profilePicture: updatedProfile.profilePicture,
          isLoading: false,
          errorMessage: null,
          isUnauthorized: false,
        ),
      );
      
      return true;
    } on UnauthorizedException catch (e) {
      // ✅ HANDLE UNAUTHORIZED
      print('Unauthorized error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: true, // ✅ SET FLAG
        ),
      );
      return false;
    } catch (e) {
      print('Error uploading profile picture: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isUnauthorized: false,
        ),
      );
      return false;
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
