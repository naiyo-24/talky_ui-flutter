import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/hive_service.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language / ভাষা নির্বাচন করুন')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await HiveService.setLanguage('bn');
                if (context.mounted) context.go('/district');
              },
              child: const Text('বাংলা (Bengali)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await HiveService.setLanguage('en');
                if (context.mounted) context.go('/district');
              },
              child: const Text('English'),
            ),
          ],
        ),
      ),
    );
  }
}
