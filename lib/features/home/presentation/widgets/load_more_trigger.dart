import 'package:flutter/material.dart';

/// Zero-size widget that fires [onVisible] once it appears in the viewport.
/// Used to trigger infinite-scroll pagination without a scroll listener.
class LoadMoreTrigger extends StatefulWidget {
  const LoadMoreTrigger({super.key, required this.onVisible});
  final VoidCallback onVisible;

  @override
  State<LoadMoreTrigger> createState() => _LoadMoreTriggerState();
}

class _LoadMoreTriggerState extends State<LoadMoreTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.onVisible());
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
