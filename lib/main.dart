import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_cubit.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/pages/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. BookingCubit
        BlocProvider<BookingCubit>(create: (context) => BookingCubit()),

        //2. Dashboard Cubit
        BlocProvider<DashboardCubit>(
          create:
              (context) =>
                  DashboardCubit(bookingCubit: context.read<BookingCubit>()),
        ),

        // 3. User Profile Cubit
        // BlocProvider<ProfileCubit>(
        //   create: (context) => ProfileCubit(),
        // ),

        // 4. Authentication Cubit
        // BlocProvider<AuthCubit>(
        //   create: (context) => AuthCubit(),
        // ),
      ],
      child: MaterialApp(
        title: 'TopTen Bali Tour',
        theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
        home: DashboardPage(),
        debugShowCheckedModeBanner: false,

        // Contoh routes untuk multiple pages
        routes: {
          '/bookings': (context) => BookingListPage(),
          // '/drivers': (context) => DriverListPage(),
          // '/profile': (context) => ProfilePage(),
          // '/login': (context) => LoginPage(),
        },

        // Atau menggunakan onGenerateRoute untuk routing yang lebih kompleks
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/bookings':
        //       return MaterialPageRoute(builder: (_) => BookingListPage());
        //     case '/drivers':
        //       return MaterialPageRoute(builder: (_) => DriverListPage());
        //     default:
        //       return MaterialPageRoute(builder: (_) => BookingListPage());
        //   }
        // },
      ),
    );
  }
}
