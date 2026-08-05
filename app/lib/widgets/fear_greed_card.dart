import 'package:flutter/material.dart';

class FearGreedCard extends StatelessWidget {
  final double value;

  const FearGreedCard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    String label;

    if (value <= 25) {
      bgColor = Colors.red[900]!;
      label = 'Extreme Fear';
    } else if (value <= 45) {
      bgColor = Colors.orange;
      label = 'Fear';
    } else if (value <= 55) {
      bgColor = Colors.grey;
      label = 'Neutral';
    } else if (value <= 75) {
      bgColor = Colors.lightGreen;
      label = 'Greed';
    } else {
      bgColor = Colors.green[900]!;
      label = 'Extreme Greed';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Fear & Greed Index',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
