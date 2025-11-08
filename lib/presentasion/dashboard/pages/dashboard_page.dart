import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptenbalitour_app/logic/booking/booking_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_cubit.dart';
import 'package:toptenbalitour_app/logic/dashboard/dashboard_state.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/dashboard_statistic.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/booking_terbaru_section.dart';
import 'package:toptenbalitour_app/presentasion/dashboard/widgets/driver_aktif_section.dart';
import 'package:toptenbalitour_app/presentasion/booking/pages/booking_list_page.dart';
import 'package:toptenbalitour_app/presentasion/driver/pages/driver_schedule.dart';
import 'package:toptenbalitour_app/presentasion/profile/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  DashboardCubit? _dashboardCubit;

  final List<String> _pageTitles = [
    'TOPTEN BALI TOUR',
    'Daftar Booking',
    'Jadwal Driver',
    'Profil Pengguna', 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingCubit = context.read<BookingCubit>();
      setState(() {
        _dashboardCubit = DashboardCubit(bookingCubit: bookingCubit);
        _dashboardCubit!.loadDashboardData();
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF2B3264);

    if (_dashboardCubit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> widgetOptions = <Widget>[
      BlocProvider.value(
        value: _dashboardCubit!,
        child: const DashboardContent(),
      ),
      const BookingListPage(key: PageStorageKey('Booking')),
      const DriverSchedulePage(key: PageStorageKey('Driver')),
      const ProfilePage(key: PageStorageKey('Profile')),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: _selectedIndex != 0, // Tengah untuk selain Dashboard
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Belum ada notifikasi.')),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IndexedStack(index: _selectedIndex, children: widgetOptions),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            activeIcon: Icon(Icons.directions_car),
            label: 'Driver',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
                Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                const SizedBox(height: 12),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<DashboardCubit>().refreshDashboard();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B3264),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is DashboardLoaded) {
          return Container(
            color: const Color(0xFFF5F6FA),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardStatistics(summary: state.summary),
                  const SizedBox(height: 20),
                  BookingTerbaruSection(bookings: state.summary.bookingTerbaru),
                  const SizedBox(height: 20),
                  const DriverAktifSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: Text(
            'Tekan tombol refresh untuk memuat data.',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        );
      },
    );
  }
}
