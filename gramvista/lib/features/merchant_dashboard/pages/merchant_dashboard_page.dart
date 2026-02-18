import 'package:flutter/material.dart';
import 'package:gramvista/features/merchant_dashboard/pages/merchantbankformpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'merchant_register_page.dart';
import 'marketplace_page.dart';
import 'profile_settings_page.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  final supabase = Supabase.instance.client;
  bool loading = true;

  int bookingCount = 0;
  Map<String, double> reviewDist = {};
  List<Map<String, dynamic>> topReviews = [];
  List<Map<String, dynamic>> submissions = [];

  Future<void> _loadData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final sidRes = await supabase
        .from('community_submissions')
        .select('id, name, is_peer_verified, is_ngo_verified, is_admin_approved, is_featured, promotion_expiry')
        .eq('user_id', user.id);
    submissions = List<Map<String, dynamic>>.from(sidRes);

    final bookingRes = await supabase
        .from('bookings')
        .select('*', const FetchOptions(count: CountOption.exact))
        .eq('user_id', user.id);
    bookingCount = bookingRes.count ?? 0;

    if (submissions.isEmpty) {
      setState(() => loading = false);
      return;
    }

    final subIds = submissions.map((s) => s['id']).toList();

    final ratings = await supabase
        .from('reviews')
        .select('rating')
        .in_('submission_id', subIds);
    reviewDist = {};
    for (final r in ratings) {
      String key = '${r['rating']}★';
      reviewDist[key] = (reviewDist[key] ?? 0) + 1;
    }

    final resp = await supabase
        .from('reviews')
        .select('comment')
        .in_('submission_id', subIds)
        .order('rating', ascending: false)
        .limit(3);
    topReviews = List<Map<String, dynamic>>.from(resp);

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSettingsPage()),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Merchant!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      'Total Bookings',
                      bookingCount.toString(),
                      Icons.book_online,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (submissions.isNotEmpty)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final submissionId = submissions[0]['id'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MerchantBankFormPage(submissionId: submissionId),
                            ),
                          );
                        },
                        child: _infoCard(
                          'Bank Details',
                          'Click to add',
                          Icons.account_balance,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Review Ratings Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: reviewDist.entries.map((e) {
                      return PieChartSectionData(
                        color: Colors.primaries[e.key.length % Colors.primaries.length],
                        value: e.value,
                        title: e.key,
                        radius: 50,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Top Reviews:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...topReviews.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• ${r['comment']}', style: const TextStyle(fontSize: 15)),
                  )),
              const SizedBox(height: 30),
              const Text(
                'Submission Status:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...submissions.map((s) => Card(
                    child: ListTile(
                      title: Text(s['name'] ?? ''),
                      subtitle: Text(
                        'Peer Verified: ${s['is_peer_verified'] ? '✅' : '❌'}\n'
                        'NGO Verified: ${s['is_ngo_verified'] ? '✅' : '❌'}\n'
                        'Admin Approved: ${s['is_admin_approved'] ? '✅' : '❌'}\n'
                        '${s['is_featured'] != null ? 'Featured: ${s['is_featured'] ? '⭐ Yes' : 'No'}\n' : ''}'
                        'Promotion Expiry: ${s['promotion_expiry'] ?? '-'}',
                      ),
                    ),
                  )),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.store_mall_directory),
                label: const Text('Update Marketplace Details'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MerchantRegisterPage()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Give Suggestions'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MarketplacePage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.green[700]),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
