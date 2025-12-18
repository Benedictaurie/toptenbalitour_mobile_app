import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toptenbalitour_app/data/repositories/booking_repository.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_cubit.dart';
import 'package:toptenbalitour_app/logic/auth/auth_cubit.dart';
import 'package:toptenbalitour_app/logic/setting/setting_cubit.dart'; // ✅ TAMBAHKAN

import 'package:toptenbalitour_app/presentasion/auth/pages/login_page.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/pages/dashboard_page.dart';
import 'package:toptenbalitour_app/presentasion/driver/pages/driver_schedule.dart';
import 'package:toptenbalitour_app/presentasion/profile/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final hasToken = prefs.getString('auth_token') != null;
  
  runApp(MyApp(hasToken: hasToken));
}

class MyApp extends StatelessWidget {
  final bool hasToken;
  
  const MyApp({super.key, required this.hasToken});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
        
        // ✅ TAMBAHKAN: SettingCubit global
        BlocProvider<SettingCubit>(
          create: (_) => SettingCubit()..loadSettings(),
        ),

        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(BookingRepository()),
          lazy: true,
        ),

        BlocProvider<DashboardCubit>(
          create: (context) => DashboardCubit(
            bookingRepository: BookingRepository(),
          ),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'TOPTEN BALI TOUR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2B3264),
          ),
        ),
        
        initialRoute: hasToken ? '/dashboard' : '/login',
        
        routes: {
          '/login': (context) => LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/bookings': (context) => const BookingListPage(),
          '/drivers': (context) => const DriverSchedulePage(),
          '/profile': (context) => const ProfilePage(),
        },
        
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => LoginPage(),
          );
        },
      ),
    );
  }
}
