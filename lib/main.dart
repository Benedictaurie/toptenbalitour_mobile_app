import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_cubit.dart';

import 'package:toptenbalitour_app/presentasion/auth/pages/login_page.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/pages/dashboard_page.dart';
import 'package:toptenbalitour_app/presentasion/driver/pages/driver_schedule.dart';
import 'package:toptenbalitour_app/presentasion/profile/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// BookingCubit — WAJIB ADA Repository
        BlocProvider<BookingCubit>(
          create:
              (context) => BookingCubit(BookingRepository())..loadBookings(),
        ),

        /// DashboardCubit — wajib menerima bookingCubit
        BlocProvider<DashboardCubit>(
          create:
              (context) =>
                  DashboardCubit(bookingRepository: BookingRepository())
                    ..loadDashboardData(),
        ),
      ],
      child: MaterialApp(
        title: 'TOPTEN BALI TOUR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, primarySwatch: Colors.green),
        home: LoginPage(),

        routes: {
          '/bookings': (context) => const BookingListPage(),
          '/drivers': (context) => const DriverSchedulePage(),
          '/profile': (context) => ProfilePage(userId: "USER_ID_DEFAULT"),
          '/login': (context) => LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}
