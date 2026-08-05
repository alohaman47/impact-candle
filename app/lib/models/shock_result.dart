class ShockResult {
  final String event;
  final Map<String, double> scores;
  final Map<String, String> reasons;
  final double confidence;
  final String summary;

  ShockResult({
    required this.event,
    required this.scores,
    required this.reasons,
    required this.confidence,
    required this.summary,
  });
}
