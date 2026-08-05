import 'package:flutter/material.dart';
import '../services/impact_service.dart';

class WeeklyRecommendationCard extends StatelessWidget {
  const WeeklyRecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final weekly = ImpactService.getWeeklyRecommendation();
    final primary = weekly['primary'] as Map<String, dynamic>;
    final secondary = weekly['secondary'] as Map<String, dynamic>;
    final avoid = weekly['avoid'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_view_week, size: 20),
              SizedBox(width: 8),
              Text(
                'Weekly Recommendation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildItem(
            title: 'Primary Focus',
            asset: primary['asset'],
            direction: primary['direction'],
            strength: primary['strength'],
            reason: primary['reason'],
          ),
          const SizedBox(height: 12),
          _buildItem(
            title: 'Secondary',
            asset: secondary['asset'],
            direction: secondary['direction'],
            strength: secondary['strength'],
            reason: secondary['reason'],
          ),
          const SizedBox(height: 12),
          const Divider(),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                'Avoid: ${avoid['asset']}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            avoid['reason'],
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            weekly['summary'],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String asset,
    required String direction,
    required String strength,
    required String reason,
  }) {
    final isLong = direction == 'Long';
    final color = isLong ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(asset, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$strength $direction',
                style: TextStyle(
                  color: color[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(reason, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
      ],
    );
  }
}
