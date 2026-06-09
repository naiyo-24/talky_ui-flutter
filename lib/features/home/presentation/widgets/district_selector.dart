import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../features/home/providers/home_provider.dart';

const _kAccent = Color(0xFFE53935);

/// Location pill that lets users filter news by district.
/// Reads/writes to [HiveService] and invalidates relevant providers on change.
class DistrictSelector extends ConsumerStatefulWidget {
  const DistrictSelector({super.key});

  @override
  ConsumerState<DistrictSelector> createState() => _DistrictSelectorState();
}

class _DistrictSelectorState extends ConsumerState<DistrictSelector> {
  late String _currentDistrict;

  @override
  void initState() {
    super.initState();
    _currentDistrict = HiveService.district;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final List<String> options = ['All Bengal', ...AppConstants.districts];
    final displayValue =
        options.contains(_currentDistrict) || _currentDistrict.isEmpty
            ? (_currentDistrict.isEmpty ? 'All Bengal' : _currentDistrict)
            : _currentDistrict;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 16, color: _kAccent),
          const SizedBox(width: 6),
          Text(
            'Local News:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: displayValue,
                isDense: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: _kAccent),
                dropdownColor: scheme.surface,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _kAccent,
                ),
                items: options.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(color: scheme.onSurface)),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  if (newValue != null && newValue != displayValue) {
                    setState(() {
                      _currentDistrict =
                          newValue == 'All Bengal' ? '' : newValue;
                    });
                    await HiveService.setDistrict(_currentDistrict);
                    ref.invalidate(breakingNewsProvider);
                    ref.read(homeNewsProvider.notifier).refresh();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
