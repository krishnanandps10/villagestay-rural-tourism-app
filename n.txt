import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final supabase = Supabase.instance.client;
  List submissions = [];
  bool _loading = true;
  Map<String, String> suggestions = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final res = await supabase
          .from('community_submissions')
          .select('id, name, status')
          .eq('user_id', user.id);

      submissions = res;

      if (submissions.isEmpty) {
        submissions = [
          {'id': 'demo1', 'name': 'Kerala Culture Stay', 'status': 'approved'},
          {'id': 'demo2', 'name': 'Eco Art Workshop', 'status': 'pending'},
        ];
        suggestions['demo1'] = 'Highlight your eco-friendliness and authentic experience.';
        suggestions['demo2'] = 'Emphasize hands-on activities to attract younger audiences.';
      } else {
        await Future.wait(submissions.map((submission) async {
          final sid = submission['id'];
          final reviewRes = await supabase
              .from('reviews')
              .select('comment')
              .eq('submission_id', sid)
              .limit(5);

          final comments = List<Map<String, dynamic>>.from(reviewRes)
              .map((r) => r['comment'])
              .join('\n');

          final suggestion = await generateGeminiSuggestion(comments);
          suggestions[sid.toString()] = suggestion;
        }));
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading data')),
      );
    }

    setState(() => _loading = false);
  }

  Future<String> generateGeminiSuggestion(String reviewText) async {
    if (reviewText.trim().isEmpty) return "Not enough reviews yet.";

    const apiKey = 'AIzaSyBXoODpkyU7_NqqOVcOLO2t3F0mJfOKt0c';

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
        responseMimeType: 'text/plain',
      ),
    );

    try {
      final prompt = "Suggest an improvement or summary for this marketplace listing based on the following reviews:\n$reviewText";
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);
      return response.text ?? 'No suggestion available.';
    } catch (e) {
      debugPrint('Gemini error: $e');
      return 'Failed to generate suggestion.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Marketplace Listings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: submissions.length,
              itemBuilder: (_, i) {
                final s = submissions[i];
                final suggestion =
                    suggestions[s['id'].toString()] ?? 'Loading suggestion...';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(s['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${s['status'] ?? ''}'),
                        const SizedBox(height: 8),
                        Text(
                          '🌟 Gemini Suggestion:\n$suggestion',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
