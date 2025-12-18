import 'package:toptenbalitour_app/data/models/dashboard_model.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Dashboard summary;

  const DashboardLoaded(this.summary);
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}

// ✅ TAMBAHKAN: State untuk handle unauthorized (401)
class DashboardUnauthorized extends DashboardState {
  final String message;

  const DashboardUnauthorized(this.message);
}
