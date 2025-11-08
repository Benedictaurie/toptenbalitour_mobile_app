import 'package:flutter/material.dart';
import 'package:toptenbalitour_app/presentasion/setting/pages/setting_page.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Ensure no extra padding at the top for the DrawerHeader
        padding: EdgeInsets.zero,
        children: <Widget>[
          // --- Drawer Header Section ---
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 43, 50, 100), // Custom dark blue color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.account_circle,
                    size: 40,
                    color: Color.fromARGB(255, 43, 50, 100),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Admin TopTen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@toptenbalitour.com',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // --- Menu Items Section (No Divider) ---
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Peraturan'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer dulu
              Future.delayed(const Duration(milliseconds: 250), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              });
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
              Navigator.pop(context); // Close the drawer after tap
            },
          ),
        ],
      ),
    );
  }
}
