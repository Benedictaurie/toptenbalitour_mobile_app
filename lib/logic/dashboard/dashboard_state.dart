import 'package:toptenbalitour_app/data/models/dashboard_model.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final Dashboard summary;

  const DashboardLoaded(this.summary);
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
//