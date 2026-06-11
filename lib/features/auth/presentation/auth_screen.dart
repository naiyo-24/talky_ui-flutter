import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isOfficialLogin = false;
  
  final _nameController = TextEditingController();
  final _identityNumberController = TextEditingController();
  String? _selectedDesignation;

  final List<String> _designations = [
    'Police',
    'Lawyer',
    'News Channel',
    'Government Employee',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _identityNumberController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (isOfficialLogin) {
      if (_selectedDesignation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your designation')),
        );
        return;
      }
      final idNumber = _identityNumberController.text.trim();
      if (idNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your Enrollment/CIN Number')),
        );
        return;
      }

      ref.read(authProvider.notifier).loginAsOfficial(
        name: name,
        designation: _selectedDesignation!,
        identityNumber: idNumber,
      );
    } else {
      ref.read(authProvider.notifier).loginAsNormal(name);
    }

    // Success login - simply pop or let the UI react to the authProvider state change
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Welcome to Community',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please sign in to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          // Tabs
          Row(
            children: [
              Expanded(
                child: _TabButton(
                  label: 'Normal User',
                  isSelected: !isOfficialLogin,
                  onTap: () => setState(() => isOfficialLogin = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TabButton(
                  label: 'Official',
                  isSelected: isOfficialLogin,
                  onTap: () => setState(() => isOfficialLogin = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          if (isOfficialLogin) ...[
            DropdownButtonFormField<String>(
              value: _selectedDesignation,
              decoration: InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _designations.map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (val) => setState(() => _selectedDesignation = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _identityNumberController,
              decoration: InputDecoration(
                labelText: 'Enrollment / CIN Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Note: Officials can post in the community. Normal users are read-only.',
              style: TextStyle(color: scheme.primary, fontSize: 13),
            ),
          ],
          
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _handleLogin,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? scheme.onPrimary : scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
