import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cats = AppConstants.exploreCategories;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text(
          'CATEGORIES',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        backgroundColor: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: cats.length,
        separatorBuilder: (context, index) => Divider(
          color: scheme.onSurface.withValues(alpha: 0.05),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final cat = cats[index];
          final label = cat['label'] as String;
          final emoji = cat['emoji'] as String;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            title: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withValues(alpha: 0.3),
            ),
            onTap: () => context.push('/category/$label'),
          );
        },
      ),
    );
  }
}
