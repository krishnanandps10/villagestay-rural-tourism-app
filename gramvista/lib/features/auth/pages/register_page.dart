import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../home/pages/explore_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final supabase = Supabase.instance.client;
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _merchantThemeController = TextEditingController();
  final TextEditingController _merchantSpecificController = TextEditingController();
  final TextEditingController _industryNameController = TextEditingController();

  final TextEditingController _ngoContactController = TextEditingController();

  String _role = 'tourist';

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      final authResponse = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) throw 'Signup failed.';

      final userData = {
        'auth_id': user.id,
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'role': _role,
        'created_at': DateTime.now().toIso8601String(),
        if (_role == 'merchant') ...{
          'merchant_theme': _merchantThemeController.text.trim(),
          'merchant_specific_value': _merchantSpecificController.text.trim(),
          'industry_name': _industryNameController.text.trim(),
        },
        if (_role == 'ngo') ...{
          'ngo_contact_number': _ngoContactController.text.trim(),
        },
      };

      await supabase.from('users').insert(userData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  ExplorePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _merchantThemeController.dispose();
    _merchantSpecificController.dispose();
    _industryNameController.dispose();
    _ngoContactController.dispose();
    super.dispose();
  }

  Widget _buildRoleSpecificFields() {
    switch (_role) {
      case 'merchant':
        return Column(
          children: [
            TextField(
              controller: _merchantThemeController,
              decoration: const InputDecoration(labelText: 'Theme of Service'),
            ),
            TextField(
              controller: _merchantSpecificController,
              decoration: const InputDecoration(labelText: 'Specific Value'),
            ),
            TextField(
              controller: _industryNameController,
              decoration: const InputDecoration(labelText: 'Industry Name'),
            ),
          ],
        );
      case 'ngo':
        return TextField(
          controller: _ngoContactController,
          decoration: const InputDecoration(labelText: 'NGO Contact Number'),
          keyboardType: TextInputType.phone,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Select Role'),
              items: const [
                DropdownMenuItem(value: 'tourist', child: Text('Tourist')),
                DropdownMenuItem(value: 'merchant', child: Text('Merchant')),
                DropdownMenuItem(value: 'ngo', child: Text('NGO')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (val) => setState(() => _role = val ?? 'tourist'),
            ),
            const SizedBox(height: 16),
            _buildRoleSpecificFields(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Register & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
