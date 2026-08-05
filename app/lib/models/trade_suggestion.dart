class TradeSuggestion {
  final String asset;
  final String direction; // Long / Short / Neutral
  final String strength;  // Strong / Moderate / Caution
  final String reason;
  final String timeframe;
  final double confidence;

  TradeSuggestion({
    required this.asset,
    required this.direction,
    required this.strength,
    required this.reason,
    required this.timeframe,
    required this.confidence,
  });
}
