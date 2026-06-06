import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class LocalIssuesScreen extends StatefulWidget {
  const LocalIssuesScreen({super.key});

  @override
  State<LocalIssuesScreen> createState() => _LocalIssuesScreenState();
}

class _LocalIssuesScreenState extends State<LocalIssuesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _districtController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Mock Submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Issue reported successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.reportIssue),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: scheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Report problems like broken roads, water issues, or electricity outages.',
                        style: TextStyle(color: scheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Issue Title',
                  hintText: 'e.g. Broken Road in Howrah',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: 'District / Area',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_on_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please specify the area' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please describe the issue' : null,
              ),
              const SizedBox(height: 16),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo upload coming soon!')),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded, color: scheme.primary),
                      const SizedBox(height: 8),
                      Text('Upload Photo (Optional)', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
