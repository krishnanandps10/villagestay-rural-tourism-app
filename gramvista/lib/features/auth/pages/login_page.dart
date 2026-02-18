import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../admin_dashboard/pages/admin_dashboard_page.dart'; // admin
// Dashboard imports (adjust the paths as needed)
import '../../home/pages/explore_page.dart'; // tourist
import '../../merchant_dashboard/pages/merchant_dashboard_page.dart'; // merchant
import '../../ngo_dashboard/pages/ngo_dashboard_page.dart'; // ngo
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;
      if (user == null) throw 'Invalid credentials or email not confirmed.';

      // Fetch user role from Supabase 'users' table
      final data = await supabase
          .from('users')
          .select('role')
          .eq('auth_id', user.id)
          .single();

      String role = data['role'] ?? 'tourist';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('role', role);

      Widget targetPage;

      switch (role) {
        case 'merchant':
          targetPage = MerchantDashboard();
          break;
        case 'ngo':
          targetPage = NGODashboard();
          break;
        case 'admin':
          targetPage = AdminDashboard();
          break;
        case 'tourist':
        default:
          targetPage = ExplorePage();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetPage),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Error: ${error.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
  child: Image.asset(
    'assets/logo/logo2.png',
    height: 200,
    width: 900, 
    fit: BoxFit.cover,
  ),
),

              const SizedBox(height: 24),
              const Text(
                'Welcome to VillageStay',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF065F46),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Discover rural India. Login to continue.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _loading ? null : _login,
                icon: const Icon(Icons.login),
                label: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Text(
                        'Login & Explore',
                        style: TextStyle(fontSize: 16),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Powered by Village Communities 🏡',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
