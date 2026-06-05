import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/constants/app_constants.dart';

class DistrictScreen extends StatelessWidget {
  const DistrictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select District')),
      body: ListView.builder(
        itemCount: AppConstants.districts.length,
        itemBuilder: (context, index) {
          final district = AppConstants.districts[index];
          return ListTile(
            title: Text(district),
            onTap: () async {
              await HiveService.setDistrict(district);
              await HiveService.setFirstLaunch(false);
              if (context.mounted) context.go('/home');
            },
          );
        },
      ),
    );
  }
}
