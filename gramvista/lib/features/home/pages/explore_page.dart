import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'booking.dart';
import 'trending_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> marketplaces = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMarketplaces();
  }

  Future<void> _loadMarketplaces() async {
    try {
      final res = await supabase
          .from('community_submissions')
          .select('id, name, region');

      setState(() {
        marketplaces = List<Map<String, dynamic>>.from(res);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching marketplaces: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading marketplaces')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Kerala'),
        backgroundColor: Colors.teal,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Explore Authentic Kerala Experiences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(10.8505, 76.2711),
                        zoom: 7.4,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: marketplaces.map((item) {
                            return Marker(
                              width: 50.0,
                              height: 50.0,
                              point: LatLng(10.8505, 76.2711), // fallback point (or use item['lat'], item['lng'] if added)
                              child: Tooltip(
                                message: '${item['name']} — ${item['region']}',
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.teal,
                                  size: 36,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.trending_up),
                      label: const Text("View Trending Marketplaces"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TrendingMarketplacePage()),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: marketplaces.length,
                    itemBuilder: (context, index) {
                      final item = marketplaces[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.place, color: Colors.teal),
                          title: Text(item['name']),
                          subtitle: Text(item['region']),
                          trailing: ElevatedButton(
                            onPressed: () {
                              final submissionId = item['id'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookNowPage(submissionId: submissionId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                            child: const Text('Book'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
