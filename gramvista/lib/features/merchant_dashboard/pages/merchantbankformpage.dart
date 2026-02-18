import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MerchantBankFormPage extends StatefulWidget {
  final String submissionId;
  const MerchantBankFormPage({super.key, required this.submissionId});

  @override
  State<MerchantBankFormPage> createState() => _MerchantBankFormPageState();
}

class _MerchantBankFormPageState extends State<MerchantBankFormPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _branchController = TextEditingController();
  bool _submitting = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      await supabase.from('merchant_bank').insert({
        'mer_id': widget.submissionId,
        'name': _nameController.text.trim(),
        'bank_name': _bankNameController.text.trim(),
        'account number': _accountNumberController.text.trim(),
        'IFSC Code': _ifscCodeController.text.trim(),
        'Branch': _branchController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank details saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Insert error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save bank details.')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bank Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(labelText: 'Bank Name'),
                validator: (value) => value!.isEmpty ? 'Enter bank name' : null,
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter account number' : null,
              ),
              TextFormField(
                controller: _ifscCodeController,
                decoration: const InputDecoration(labelText: 'IFSC Code'),
                validator: (value) => value!.isEmpty ? 'Enter IFSC code' : null,
              ),
              TextFormField(
                controller: _branchController,
                decoration: const InputDecoration(labelText: 'Branch'),
                validator: (value) => value!.isEmpty ? 'Enter branch name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting ? null : _submitForm,
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
