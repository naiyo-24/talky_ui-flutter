// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  final Map<String, dynamic> pollData = {
    "id": 1,
    "question": "Do you think more infrastructure projects are needed in your district?",
    "options": ["Yes", "No", "Not Sure"]
  };

  String? _selectedOption;
  bool _hasVoted = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.todaysPoll),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.poll_rounded, color: scheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Poll',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pollData['question'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (_hasVoted) ...[
                    _buildResultBar('Yes', 72, scheme),
                    const SizedBox(height: 12),
                    _buildResultBar('No', 18, scheme),
                    const SizedBox(height: 12),
                    _buildResultBar('Not Sure', 10, scheme),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Thank you for your vote!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ] else ...[
                    ...(pollData['options'] as List<String>).map((option) {
                      return RadioListTile<String>(
                        title: Text(option, style: const TextStyle(fontWeight: FontWeight.w500)),
                        value: option,
                        groupValue: _selectedOption,
                        activeColor: scheme.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _selectedOption == null
                          ? null
                          : () {
                              setState(() {
                                _hasVoted = true;
                              });
                            },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Vote', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBar(String label, int percentage, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$percentage%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: scheme.surfaceContainerHighest,
          color: scheme.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
