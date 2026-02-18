import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NGOVerifySubmissionsPage extends StatefulWidget {
  const NGOVerifySubmissionsPage({super.key});

  @override
  State<NGOVerifySubmissionsPage> createState() => _NGOVerifySubmissionsPageState();
}

class _NGOVerifySubmissionsPageState extends State<NGOVerifySubmissionsPage> {
  final supabase = Supabase.instance.client;
  List submissions = [];
  bool loading = true;

  Future<void> _fetch() async {
    final response = await supabase
        .from('community_submissions')
        .select()
        .eq('is_ngo_verified', false);
    submissions = response;
    setState(() => loading = false);
  }

  Future<void> _verify(String id) async {
    await supabase
        .from('community_submissions')
        .update({'is_ngo_verified': true})
        .eq('id', id);
    await _fetch();
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submissions to Verify')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final item = submissions[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    onPressed: () => _verify(item['id']),
                  ),
                );
              },
            ),
    );
  }
}
