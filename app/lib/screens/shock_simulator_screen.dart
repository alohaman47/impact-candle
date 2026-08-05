import 'package:flutter/material.dart';
import '../models/shock_result.dart';
import '../services/impact_service.dart';
import '../theme/app_theme.dart';

class ShockSimulatorScreen extends StatefulWidget {
  const ShockSimulatorScreen({super.key});

  @override
  State<ShockSimulatorScreen> createState() => _ShockSimulatorScreenState();
}

class _ShockSimulatorScreenState extends State<ShockSimulatorScreen> {
  final TextEditingController _controller = TextEditingController();
  ShockResult? result;
  bool isLoading = false;

  final List<String> presets = [
    'Fed cuts rates aggressively',
    'Iran closes Strait of Hormuz',
    'China announces major stimulus',
    'US recession confirmed',
    'Major bank failure in Europe',
  ];

  Future<void> _simulate() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      result = null;
    });

    final res = await ImpactService.simulateEventAI(_controller.text.trim());

    setState(() {
      result = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Shock Simulator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'จำลองผลกระทบจากเหตุการณ์',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _controller,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'พิมพ์เหตุการณ์ที่ต้องการจำลอง...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: presets.map((p) {
                return ActionChip(
                  label: Text(p, style: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    _controller.text = p;
                    _simulate();
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _simulate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Simulate Impact', style: TextStyle(fontSize: 16)),
              ),
            ),

            if (result != null) ...[
              const SizedBox(height: 28),
              const Text(
                'Projected Impact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                result!.summary,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),

              ...result!.scores.entries.map((e) {
                final score = e.value;
                final isGreen = score >= 0;
                final color = isGreen ? AppTheme.greenCandle : AppTheme.redCandle;
                final reason = result!.reasons[e.key] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: 18,
                        height: (score.abs() * 8).clamp(12, 70),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              score.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Text(reason, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),
              Text(
                'Confidence: ${(result!.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
