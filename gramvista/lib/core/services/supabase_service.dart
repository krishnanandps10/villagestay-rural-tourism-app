import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/submission_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Get approved submissions
  Future<List<Submission>> fetchApprovedSubmissions() async {
    final response = await _client
        .from('community_submissions')
        .select()
        .eq('is_admin_approved', true)
        .order('promotion_expiry', ascending: false);

    final data = response as List<dynamic>;
    return data.map((json) => Submission.fromJson(json)).toList();
  }

  // Add a new listing (merchant)
  Future<void> createSubmission(Submission submission) async {
    await _client.from('community_submissions').insert(submission.toJson());
  }

  // Book a listing
  Future<void> createBooking({
    required String userId,
    required String submissionId,
    required DateTime preferredDate,
    String? message,
  }) async {
    await _client.from('bookings').insert({
      'user_id': userId,
      'submission_id': submissionId,
      'preferred_date': preferredDate.toIso8601String(),
      'message': message,
    });
  }

  // Fetch tourist bookings
  Future<List<Map<String, dynamic>>> fetchBookingsForTourist(
    String userId,
  ) async {
    final response = await _client
        .from('bookings')
        .select('*, community_submissions(name, region)')
        .eq('user_id', userId);

    return response as List<Map<String, dynamic>>;
  }

  // Fetch merchant’s submissions
  Future<List<Submission>> fetchMerchantListings(String userId) async {
    final response = await _client
        .from('community_submissions')
        .select()
        .eq('user_id', userId);

    return (response as List).map((e) => Submission.fromJson(e)).toList();
  }

  // Fetch bookings received by merchant
  Future<List<Map<String, dynamic>>> fetchMerchantBookings(
    String merchantId,
  ) async {
    final response = await _client.rpc(
      'get_bookings_for_merchant',
      params: {'merchant_id': merchantId},
    );

    return response as List<Map<String, dynamic>>;
  }
}
