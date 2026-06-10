import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/hive_service.dart';

const _kAccent = Color(0xFFE53935);

/// Location pill that displays the auto-fetched location.
class DistrictSelector extends ConsumerWidget {
  const DistrictSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final String currentLocation = HiveService.district.isNotEmpty 
        ? HiveService.district 
        : 'All India';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 16, color: _kAccent),
          const SizedBox(width: 6),
          Text(
            'Location: $currentLocation',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
