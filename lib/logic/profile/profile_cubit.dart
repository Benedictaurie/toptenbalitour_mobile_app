import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import 'package:toptenbalitour_app/data/repositories/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(const ProfileState());

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final profile = await repository.fetchProfile(userId);

      emit(state.copyWith(
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        address: profile.address,
        role: profile.role,
        imagePath: profile.imagePath ?? state.imagePath,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // bisa log error atau emit state error jika mau
      // debugPrint('Gagal load profile: $e');
    }
  }
}
