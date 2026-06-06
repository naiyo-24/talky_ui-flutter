import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _districtController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _districtController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Mock Submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.feedback),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/community');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We want to hear from you!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share your suggestions or feedback to help us improve your community.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_city_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter your district' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please provide your feedback' : null,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
