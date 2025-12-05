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
      // 🔥 Ambil data driver dari API
      final List<Driver> drivers = await repository.getDrivers();

      emit(DriverLoaded(drivers));
    } catch (e) {
      emit(DriverError('Gagal memuat data driver: $e'));
    }
  }
}
