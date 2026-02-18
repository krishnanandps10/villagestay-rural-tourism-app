import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookNowPage extends StatefulWidget {
  final String submissionId; // The merchant's listing ID

  const BookNowPage({super.key, required this.submissionId});

  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDate;
  bool _loading = false;

  Map<String, dynamic>? bankDetails;

  Future<void> _fetchBankDetails() async {
    final response = await supabase
        .from('merchant_bank')
        .select('name, bank_name, account_number, ifsc_code, branch')
        .eq('mer_id', widget.submissionId)
        .maybeSingle();

    setState(() {
      bankDetails = response;
    });
  }

  Future<void> _submitBooking() async {
    final user = supabase.auth.currentUser;
    if (user == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login and select a date.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await supabase.from('bookings').insert({
        'user_id': user.id,
        'submission_id': widget.submissionId,
        'preferred_date': _selectedDate!.toIso8601String(),
        'message': _messageController.text.trim(),
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking submitted successfully!')),
      );

      setState(() => _loading = false);
    } catch (e) {
      debugPrint('Booking error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book. Please try again.')),
      );
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Now'),
        backgroundColor: Colors.green[800],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bank Account Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
                          bankDetails == null
                              ? const Text('Loading bank details...')
                              : Text(
                                  'Beneficiary Name: ${bankDetails!['name'] ?? 'N/A'}\n'
                                  'Bank Name: ${bankDetails!['bank_name'] ?? 'N/A'}\n'
                                  'Account Number: ${bankDetails!['account_number'] ?? 'N/A'}\n'
                                  'IFSC Code: ${bankDetails!['ifsc_code'] ?? 'N/A'}\n'
                                  'Branch: ${bankDetails!['branch'] ?? 'N/A'}\n\n'
                                  'Note: Once payment is made, kindly email the receipt to bookings@athithya.in',
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Select preferred date'
                              : 'Selected: ${_selectedDate!.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: const Text('Choose Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: _submitBooking,
                    label: const Text('Submit Booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
