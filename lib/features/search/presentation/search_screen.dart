import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/search/providers/search_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/news_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final scheme = Theme.of(context).colorScheme;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        NavigationShellProvider.of(context).goBranch(0);
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (q) =>
              ref.read(searchProvider.notifier).search(q),
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                ref.read(searchProvider.notifier).clear();
              },
              icon: const Icon(Icons.clear_rounded),
            ),
        ],
        elevation: 0,
        backgroundColor: scheme.surface,
      ),
      body: Builder(builder: (context) {
        if (state.isLoading) {
          return const LoadingWidget();
        }
        if (state.error != null) {
          return AppErrorWidget(message: state.error!);
        }
        if (state.query.isEmpty) {
          return _EmptySearch();
        }
        if (state.results.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 60,
                    color: scheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(height: 12),
                Text('No results for "${state.query}"',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        )),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: state.results.length,
          itemBuilder: (_, i) => NewsCard(article: state.results[i]),
        );
      }),
    ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final suggestions = [
      'Technology', 'Sports', 'Business', 'Health', 'AI', 'Climate',
    ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Topics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions.asMap().entries.map((e) {
              return GestureDetector(
                onTap: () {
                  // Handled via SearchNotifier
                },
                child: Chip(
                  label: Text(e.value),
                  backgroundColor: scheme.surfaceContainerHighest,
                  avatar: Icon(Icons.trending_up_rounded,
                      size: 16, color: scheme.primary),
                ),
              ).animate().fadeIn(delay: (e.key * 80).ms);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

