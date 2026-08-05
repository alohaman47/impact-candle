import 'package:flutter/material.dart';
import '../models/daily_impact.dart';
import '../services/impact_service.dart';
import '../widgets/impact_candle_widget.dart';
import '../widgets/fear_greed_card.dart';
import '../widgets/social_trend_card.dart';
import '../widgets/weekly_recommendation_card.dart';
import 'detail_screen.dart';
import 'historical_screen.dart';
import 'shock_simulator_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<DailyImpact> impacts = ImpactService.getTodayImpacts();
  final DailyImpact best = ImpactService.getBestOpportunity();

  @override
  Widget build(BuildContext context) {
    final isBestLong = best.finalScore > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Candle'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoricalScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bolt),
            tooltip: 'Shock Simulator',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShockSimulatorScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FearGreedCard(value: impacts.first.fearGreedValue),

            // Best Opportunity Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isBestLong
                      ? [Colors.green.shade700, Colors.green.shade500]
                      : [Colors.red.shade700, Colors.red.shade500],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Best Opportunity Today',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        best.asset,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isBestLong ? 'LONG' : 'SHORT',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    best.topReason,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Score: ${best.finalScore.toStringAsFixed(1)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const WeeklyRecommendationCard(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Today\'s Impact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            ...impacts.map((impact) => ImpactCandleWidget(
                  impact: impact,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(impact: impact),
                    ),
                  ),
                )),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Social Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const SocialTrendCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
