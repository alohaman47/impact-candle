import 'package:flutter/material.dart';
import '../models/daily_impact.dart';
import '../services/impact_service.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  final DailyImpact impact;

  const DetailScreen({super.key, required this.impact});

  @override
  Widget build(BuildContext context) {
    final isGreen = impact.color == 'green';
    final candleColor = isGreen ? AppTheme.greenCandle : AppTheme.redCandle;
    final suggestion = ImpactService.generateSuggestion(impact);

    return Scaffold(
      appBar: AppBar(
        title: Text(impact.asset),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score ใหญ่
            Center(
              child: Column(
                children: [
                  Text(
                    impact.finalScore.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: candleColor,
                    ),
                  ),
                  Text(
                    'Impact Score',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: candleColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      impact.topReason,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Trade Suggestion
            const Text(
              'Trade Suggestion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: suggestion.direction == 'Long'
                    ? Colors.green.withOpacity(0.12)
                    : suggestion.direction == 'Short'
                        ? Colors.red.withOpacity(0.12)
                        : Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: suggestion.direction == 'Long'
                      ? Colors.green
                      : suggestion.direction == 'Short'
                          ? Colors.red
                          : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${suggestion.strength} ${suggestion.direction}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: suggestion.direction == 'Long'
                              ? Colors.green[700]
                              : suggestion.direction == 'Short'
                                  ? Colors.red[700]
                                  : Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(suggestion.confidence * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(suggestion.reason, style: const TextStyle(fontSize: 14, height: 1.4)),
                  const SizedBox(height: 8),
                  Text(
                    'Timeframe: ${suggestion.timeframe}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Score Breakdown
            const Text(
              'Score Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildScoreRow('AI News Score', impact.aiScore, 0.35),
            _buildScoreRow('Price Reaction', impact.priceReaction, 0.25),
            _buildScoreRow('Fear & Greed Adj', impact.fearGreedAdj, 0.12),
            _buildScoreRow('Social Trend', impact.socialAdj, 0.08),
            _buildScoreRow('Market Breadth', impact.breadthAdj, 0.08),
            _buildScoreRow('Volatility', impact.volatilityAdj, 0.07),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, double score, double weight) {
    final isPositive = score >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            flex: 2,
            child: Text(
              score.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isPositive ? AppTheme.greenCandle : AppTheme.redCandle,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 48,
            child: Text(
              '${(weight * 100).toStringAsFixed(0)}%',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
