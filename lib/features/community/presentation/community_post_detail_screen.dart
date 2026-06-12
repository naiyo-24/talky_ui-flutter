import 'package:flutter/material.dart';

class CommunityPostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const CommunityPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const appRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Official Notice'),
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: appRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_rounded, color: appRed, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post['author']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 20, color: appRed),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${post['designation']} • ${post['time']}',
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Content
            Text(
              post['content']!,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 32),

            // Attachment (if any)
            if (post['attachmentType'] != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(
                      post['attachmentType'] == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.map_rounded,
                      color: appRed,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['attachmentName']!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post['attachmentType'] == 'pdf' ? 'PDF Document • 2.4 MB' : 'Location Map',
                            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.download_rounded, color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            const Divider(),
            const SizedBox(height: 16),
            
            // Footer Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility_rounded, size: 18, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      post['views'] ?? '1.2k views',
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 18, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      'Verified by State',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant, 
                        fontSize: 13, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
