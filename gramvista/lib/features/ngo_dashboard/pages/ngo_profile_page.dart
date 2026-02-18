import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NGOBookingsPage extends StatefulWidget {
  const NGOBookingsPage({super.key});
  @override
  State<NGOBookingsPage> createState() => _NGOBookingsPageState();
}

class _NGOBookingsPageState extends State<NGOBookingsPage> {
  final supabase = Supabase.instance.client;
  List bookings = [];
  bool loading = true;

  Future<void> _fetchBookings() async {
    final response = await supabase
        .from('bookings')
        .select('*, community_submissions(name)')
        .order('created_at', ascending: false);
    bookings = response;
    setState(() => loading = false);
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Booked: ${b['community_submissions']['name']}'),
                    subtitle: Text('Date: ${b['preferred_date']}\nMessage: ${b['message']}'),
                    trailing: Text(b['status']),
                  ),
                );
              },
            ),
    );
  }
}
