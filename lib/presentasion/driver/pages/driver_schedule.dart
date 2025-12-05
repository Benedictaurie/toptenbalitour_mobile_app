import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/data/repositories/driver_repository.dart';
import 'package:toptenbalitour_app/logic/driver/driver_cubit.dart';
import 'package:toptenbalitour_app/logic/driver/driver_state.dart';
import 'driver_detail_page.dart';

class DriverSchedulePage extends StatelessWidget {
  const DriverSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverCubit(repository: DriverRepository())..fetchDrivers(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<DriverCubit, DriverState>(
            builder: (context, state) {
              if (state is DriverLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DriverError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Gagal memuat data driver:\n${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              } else if (state is DriverLoaded) {
                final drivers = state.drivers;

                if (drivers.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada driver terdaftar.",
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final d = drivers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(
                          d.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text("Status: ${d.status}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DriverDetailPage(driver: d),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }

              return const Center(child: Text("Memuat data driver..."));
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: const Color(0xFF2B3264),
            onPressed: () {
              context.read<DriverCubit>().fetchDrivers();
            },
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
