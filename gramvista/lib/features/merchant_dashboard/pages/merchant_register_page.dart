import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MerchantRegisterPage extends StatefulWidget {
  const MerchantRegisterPage({super.key});

  @override
  State<MerchantRegisterPage> createState() => _MerchantRegisterPageState();
}

class _MerchantRegisterPageState extends State<MerchantRegisterPage> {
  final supabase = Supabase.instance.client;

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _region = TextEditingController();
  final _images = TextEditingController();

  final List<String> _availableTags = [
    'Crafts',
    'Culture',
    'Homestay',
    'Farm',
    'Heritage',
    'Eco-tourism',
  ];

  List<String> _selectedTags = [];
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    final user = supabase.auth.currentUser;
    if (user == null) throw 'Not signed in';

    await supabase.from('community_submissions').insert({
      'user_id': user.id,
      'name': _name.text.trim(),
      'description': _description.text.trim(),
      'region': _region.text.trim(),
      'tags': _selectedTags,
      'images': _images.text.trim().split(','), // placeholder URLs
      'is_peer_verified': false,
      'is_ngo_verified': false,
      'is_admin_approved': false,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
      'is_featured': false,
      'promotion_expiry': null,
    });

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitted')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _region.dispose();
    _images.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Marketplace')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Marketplace Name')),
            const SizedBox(height: 12),
            TextField(controller: _description, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            TextField(controller: _region, decoration: const InputDecoration(labelText: 'Region')),
            const SizedBox(height: 12),

            /// Tags Dropdown
            const Text('Select Tags'),
            Wrap(
              spacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _images,
              decoration: const InputDecoration(labelText: 'Image URLs (comma separated)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? const CircularProgressIndicator() : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
