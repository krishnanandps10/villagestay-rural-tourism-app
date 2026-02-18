import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart'; // This should contain AppRouter or your root widget
import 'home-page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://jpzxizfsbdxxythfylml.supabase.co', // ✅ Your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwenhpemZzYmR4eHl0aGZ5bG1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIyMTU2MTksImV4cCI6MjA2Nzc5MTYxOX0.Z9b5dOmgBfHQyjXcHgu8vlLKVNTgIijVRVZb1YHfruI', // ✅ Your Supabase anon key
  );

  runApp(const GramVistaApp());
}

class GramVistaApp extends StatelessWidget {
  const GramVistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VillageStay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home:  HomePage(), // Will decide screen based on role/user_id
    );
  }
}
