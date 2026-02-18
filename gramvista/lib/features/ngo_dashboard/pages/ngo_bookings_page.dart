import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NGOProfilePage extends StatefulWidget {
  const NGOProfilePage({super.key});

  @override
  State<NGOProfilePage> createState() => _NGOProfilePageState();
}

class _NGOProfilePageState extends State<NGOProfilePage> {
  final supabase = Supabase.instance.client;
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _region = TextEditingController();

  bool loading = true;

  Future<void> _load() async {
    final id = supabase.auth.currentUser?.id;
    final res = await supabase
        .from('users')
        .select('full_name, ngo_contact_number, region')
        .eq('auth_id', id)
        .single();
    _name.text = res['full_name'] ?? '';
    _contact.text = res['ngo_contact_number'] ?? '';
    _region.text = res['region'] ?? '';
    setState(() => loading = false);
  }

  Future<void> _save() async {
    final id = supabase.auth.currentUser?.id;
    await supabase.from('users').update({
      'full_name': _name.text.trim(),
      'ngo_contact_number': _contact.text.trim(),
      'region': _region.text.trim(),
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
      appBar: AppBar(title: const Text('NGO Profile')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name')),
                  const SizedBox(height: 12),
                  TextField(controller: _contact, decoration: const InputDecoration(labelText: 'NGO Contact')),
                  const SizedBox(height: 12),
                  TextField(controller: _region, decoration: const InputDecoration(labelText: 'Region')),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ),
    );
  }
}
