import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/daily_impact.dart';

class ImpactCandleWidget extends StatelessWidget {
  final DailyImpact impact;
  final VoidCallback onTap;

  const ImpactCandleWidget({
    super.key,
    required this.impact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGreen = impact.color == 'green';
    final candleColor = isGreen ? AppTheme.greenCandle : AppTheme.redCandle;

    double height;
    switch (impact.candleSize) {
      case 'very_short':
        height = 30;
        break;
      case 'short':
        height = 50;
        break;
      case 'medium':
        height = 80;
        break;
      case 'long':
        height = 110;
        break;
      case 'very_long':
        height = 140;
        break;
      default:
        height = 60;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                impact.asset,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: height,
              decoration: BoxDecoration(
                color: candleColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    impact.finalScore.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: candleColor,
                    ),
                  ),
                  Text(
                    impact.topReason,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
