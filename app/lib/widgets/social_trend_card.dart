import 'package:flutter/material.dart';

class SocialTrendCard extends StatelessWidget {
  const SocialTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    final trends = [
      {'asset': 'Gold', 'score': 8.4, 'platform': 'X'},
      {'asset': 'DXY', 'score': 6.2, 'platform': 'Reddit'},
      {'asset': 'US100', 'score': 5.8, 'platform': 'X'},
    ];

    return Column(
      children: trends.map((t) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                t['asset'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Score: ${(t['score'] as double).toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  t['platform'] as String,
                  style: const TextStyle(fontSize: 11),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
