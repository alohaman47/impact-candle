import 'package:flutter/material.dart';
import '../models/historical_day.dart';
import '../models/daily_impact.dart';
import '../services/impact_service.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';

class HistoricalScreen extends StatelessWidget {
  const HistoricalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = ImpactService.getHistoricalData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Impact'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final day = history[index];
          return _buildDayCard(context, day);
        },
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, HistoricalDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.date,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  day.summary,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: day.impacts.map((impact) {
                return _buildMiniCandle(context, impact);
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMiniCandle(BuildContext context, DailyImpact impact) {
    final isGreen = impact.color == 'green';
    final color = isGreen ? AppTheme.greenCandle : AppTheme.redCandle;

    double height;
    switch (impact.candleSize) {
      case 'very_short':
        height = 18;
        break;
      case 'short':
        height = 28;
        break;
      case 'medium':
        height = 40;
        break;
      case 'long':
        height = 52;
        break;
      case 'very_long':
        height = 64;
        break;
      default:
        height = 30;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(impact: impact)),
        );
      },
      child: Container(
        width: 64,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Text(impact.asset, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              width: 14,
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              impact.finalScore.toStringAsFixed(1),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
