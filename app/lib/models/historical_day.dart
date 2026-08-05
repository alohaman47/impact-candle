import 'daily_impact.dart';

class HistoricalDay {
  final String date;
  final List<DailyImpact> impacts;
  final String summary;

  HistoricalDay({
    required this.date,
    required this.impacts,
    required this.summary,
  });
}
