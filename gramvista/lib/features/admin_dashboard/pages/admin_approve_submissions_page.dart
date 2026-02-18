import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminApproveSubmissionsPage extends StatefulWidget {
  const AdminApproveSubmissionsPage({super.key});

  @override
  State<AdminApproveSubmissionsPage> createState() => _AdminApproveSubmissionsPageState();
}

class _AdminApproveSubmissionsPageState extends State<AdminApproveSubmissionsPage> {
  final supabase = Supabase.instance.client;
  List submissions = [];

  Future<void> _fetch() async {
    final res = await supabase
        .from('community_submissions')
        .select()
        .eq('is_admin_approved', false);
    setState(() => submissions = res);
  }

  Future<void> _approve(String id) async {
    await supabase
        .from('community_submissions')
        .update({'is_admin_approved': true})
        .eq('id', id);
    _fetch();
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Approvals')),
      body: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (_, i) {
          final s = submissions[i];
          return ListTile(
            title: Text(s['name']),
            subtitle: Text(s['description']),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () => _approve(s['id']),
            ),
          );
        },
      ),
    );
  }
}
