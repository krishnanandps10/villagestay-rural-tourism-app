import 'package:flutter/material.dart';
import 'ngo_profile_page.dart';
import 'ngo_verify_submissions_page.dart';
import 'ngo_bookings_page.dart';

class NGODashboard extends StatelessWidget {
  const NGODashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NGOProfilePage()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome, NGO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.verified_outlined),
              label: const Text('Verify Community Submissions'),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NGOVerifySubmissionsPage()));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.book_online),
              label: const Text('View All Bookings'),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NGOBookingsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
