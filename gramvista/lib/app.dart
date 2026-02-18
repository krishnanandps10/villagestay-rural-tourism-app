import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/pages/explore_page.dart';
import 'features/auth/pages/login_page.dart';
// import 'features/booking/pages/tourist_booking_page.dart';
// import 'features/submissions/pages/add_listing_page.dart';
// import 'features/admin/pages/admin_panel.dart';
// import 'features/merchant_dashboard/pages/merchant_dashboard_page.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  String? role;
  String? userId;

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
      userId = prefs.getString('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null || userId == null) {
      return const LoginPage(); // Default to login
    }

    switch (role) {
      case 'tourist':
        return ExplorePage();
      // case 'merchant':
      //   return const MerchantDashboardPage();
      // case 'admin':
      //   return const AdminPanelPage();
      default:
        return const LoginPage();
    }
  }
}
