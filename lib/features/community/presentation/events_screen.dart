import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> events = [
      {
        "title": "Youth Meeting",
        "district": "Kolkata",
        "date": "2026-06-12"
      },
      {
        "title": "Public Awareness Program",
        "district": "Howrah",
        "date": "2026-06-15"
      },
      {
        "title": "Infrastructure Townhall",
        "district": "Hooghly",
        "date": "2026-06-20"
      },
      {
        "title": "Women Empowerment Rally",
        "district": "South 24 Parganas",
        "date": "2026-06-25"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.upcomingEvents),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final event = events[index];
          final date = DateTime.parse(event['date']);
          
          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: scheme.surfaceContainerHighest),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 16, color: scheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            event['district'],
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.3)),
              ],
            ),
          );
        },
      ),
    );
  }
}
