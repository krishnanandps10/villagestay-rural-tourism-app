import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final supabase = Supabase.instance.client;
  List users = [];

  Future<void> _fetchUsers() async {
    final res = await supabase.from('users').select();
    setState(() => users = res);
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            title: Text(u['full_name'] ?? 'Unnamed'),
            subtitle: Text('${u['email']} - Role: ${u['role']}'),
          );
        },
      ),
    );
  }
}
