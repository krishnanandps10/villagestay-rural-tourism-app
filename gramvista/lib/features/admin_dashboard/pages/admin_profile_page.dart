import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final supabase = Supabase.instance.client;
  final _name = TextEditingController();
  final _email = TextEditingController();

  Future<void> _load() async {
    final id = supabase.auth.currentUser?.id;
    final res = await supabase
        .from('users')
        .select('full_name, email')
        .eq('auth_id', id)
        .single();
    _name.text = res['full_name'] ?? '';
    _email.text = res['email'] ?? '';
  }

  Future<void> _save() async {
    final id = supabase.auth.currentUser?.id;
    await supabase.from('users').update({
      'full_name': _name.text.trim(),
    }).eq('auth_id', id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile Updated')));
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
