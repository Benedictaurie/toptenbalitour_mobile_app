import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_state.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/dashboard_statistic.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/booking_terbaru_section.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/dashboard_actions.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/dashboard_drawer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard TopTen Bali Tour'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardCubit>().refreshDashboard();
            },
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: BlocProvider(
        create:
            (context) =>
                DashboardCubit(bookingCubit: context.read<BookingCubit>())
                  ..loadDashboardData(),
        child: const DashboardContent(),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<DashboardCubit>().refreshDashboard();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DashboardStatistics(summary: state.summary),
                const SizedBox(height: 20),
                BookingTerbaruSection(bookings: state.summary.bookingTerbaru),
                const SizedBox(height: 20),
                // JadwalDriverSection(jadwal: state.summary.jadwalDriverHariIni),
                // const SizedBox(height: 20),
                const DashboardActions(),
              ],
            ),
          );
        }

        return const Center(child: Text('Tekan refresh untuk memuat data'));
      },
    );
  }
}
