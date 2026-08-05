class DailyImpact {
  final String asset;
  final String date;
  final double finalScore;
  final double aiScore;
  final double priceReaction;
  final double fearGreedAdj;
  final double socialAdj;
  final double breadthAdj;
  final double volatilityAdj;
  final String color;
  final String candleSize;
  final String topReason;
  final double fearGreedValue;

  DailyImpact({
    required this.asset,
    required this.date,
    required this.finalScore,
    required this.aiScore,
    required this.priceReaction,
    required this.fearGreedAdj,
    required this.socialAdj,
    required this.breadthAdj,
    required this.volatilityAdj,
    required this.color,
    required this.candleSize,
    required this.topReason,
    required this.fearGreedValue,
  });
}
