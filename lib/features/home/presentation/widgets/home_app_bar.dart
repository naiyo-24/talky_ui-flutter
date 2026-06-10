import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kAccent = Color(0xFFE53935);

/// Persistent SliverAppBar with logo, search, and notification bell.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: scheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Builder(builder: (ctx) {
          return IconButton(
            icon: Icon(Icons.menu_rounded, color: scheme.onSurface, size: 26),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          );
        }),
      ),
      title: Image.asset(
        isDark
            ? 'assets/images/Logo_For_Dark_Mode.png'
            : 'assets/images/Logo_Without_BG.png',
        width: 140,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: scheme.onSurface),
          onPressed: () => context.go('/search'),
        ),
        // Notification bell with red dot badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon:
                  Icon(Icons.notifications_outlined, color: scheme.onSurface),
              onPressed: () => context.push('/notifications'),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _kAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
