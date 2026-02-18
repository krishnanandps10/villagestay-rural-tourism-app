import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminBookingsPage extends StatefulWidget {
  const AdminBookingsPage({super.key});

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  final supabase = Supabase.instance.client;
  List bookings = [];

  Future<void> _fetchBookings() async {
    final response = await supabase
        .from('bookings')
        .select('*, community_submissions(name)')
        .order('created_at', ascending: false);
    setState(() => bookings = response);
  }

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Bookings')),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (_, i) {
          final b = bookings[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Booking: ${b['community_submissions']['name']}'),
              subtitle: Text('Date: ${b['preferred_date']}\nMessage: ${b['message']}'),
              trailing: Text(b['status']),
            ),
          );
        },
      ),
    );
  }
}
