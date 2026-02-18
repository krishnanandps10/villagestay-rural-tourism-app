import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrendingMarketplacePage extends StatefulWidget {
  const TrendingMarketplacePage({super.key});

  @override
  State<TrendingMarketplacePage> createState() => _TrendingMarketplacePageState();
}

class _TrendingMarketplacePageState extends State<TrendingMarketplacePage> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  List<Map<String, dynamic>> trending = [];

  final List<Map<String, dynamic>> dummyTrending = [
    {
      'name': 'Pottery Village',
      'region': 'Rajasthan',
      'average_rating': 4.8,
    },
    {
      'name': 'Organic Farm Stay',
      'region': 'Kerala',
      'average_rating': 4.6,
    },
    {
      'name': 'Himalayan Homestay',
      'region': 'Uttarakhand',
      'average_rating': 4.5,
    },
  ];

  Future<void> loadTrending() async {
    try {
      final submissions = await supabase
          .from('community_submissions')
          .select('id, name, region, is_featured')
          .eq('is_featured', true);

      if (submissions == null || submissions.isEmpty) {
        setState(() {
          trending = dummyTrending;
          loading = false;
        });
        return;
      }

      final ids = submissions.map((s) => s['id']).toList();

      final ratings = await supabase
          .from('reviews')
          .select('submission_id, rating');

      final Map<int, List<int>> ratingMap = {};
      for (final r in ratings) {
        final sid = r['submission_id'];
        final rating = r['rating'];
        if (ids.contains(sid)) {
          ratingMap.putIfAbsent(sid, () => []).add(rating);
        }
      }

      for (final sub in submissions) {
        final sid = sub['id'];
        final subRatings = ratingMap[sid] ?? [];
        final double avgRating = subRatings.isNotEmpty
            ? subRatings.reduce((a, b) => a + b) / subRatings.length
            : 0.0;
        sub['average_rating'] = avgRating;
      }

      submissions.sort((a, b) => (b['average_rating']).compareTo(a['average_rating']));

      setState(() {
        trending = List<Map<String, dynamic>>.from(submissions);
        loading = false;
      });
    } catch (e) {
      setState(() {
        trending = dummyTrending;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trending Marketplaces')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : trending.isEmpty
              ? const Center(child: Text('No trending data found.'))
              : ListView.builder(
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    final item = trending[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Colors.orange),
                        title: Text(item['name']),
                        subtitle: Text(
                          'Region: ${item['region'] ?? 'N/A'}\nRating: ${item['average_rating'].toStringAsFixed(1)} ★',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
