import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/driver/driver_state.dart';
import 'package:toptenbalitour_app/data/models/driver_model.dart';
import 'package:toptenbalitour_app/data/repositories/driver_repository.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository repository;

  DriverCubit({required this.repository}) : super(DriverInitial());

  Future<void> fetchDrivers() async {
    emit(DriverLoading());
    try {
      // --- Dummy data sementara ---
      await Future.delayed(const Duration(seconds: 1)); // simulasi loading

      final drivers = [
        Driver(
          id: 1,
          name: 'Komang Adi',
          phone: '081234567890',
          vehicleType: 'Toyota Avanza',
          licensePlate: 'DK 1234 XX',
          status: 'active',
          lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        Driver(
          id: 2,
          name: 'Made Budi',
          phone: '081987654321',
          vehicleType: 'Suzuki Ertiga',
          licensePlate: 'DK 5678 YY',
          status: 'on-duty',
          lastActive: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Driver(
          id: 3,
          name: 'Ketut Wayan',
          phone: '081345678912',
          vehicleType: 'Honda Mobilio',
          licensePlate: 'DK 9999 ZZ',
          status: 'inactive',
          lastActive: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      emit(DriverLoaded(drivers));
    } catch (e) {
      emit(DriverError('Gagal memuat data driver: $e'));
    }
  }
}
