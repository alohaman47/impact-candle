import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daily_impact.dart';
import '../models/trade_suggestion.dart';
import '../models/shock_result.dart';
import '../models/historical_day.dart';

class ImpactService {
  // เปลี่ยนเป็น IP เครื่องที่รัน Backend ตอนทดสอบจริง
  static const String baseUrl = "http://10.0.2.2:8000";

  static List<DailyImpact> getTodayImpacts() {
    return [
      DailyImpact(
        asset: 'Gold',
        date: '2026-08-05',
        finalScore: 7.2,
        aiScore: 6.5,
        priceReaction: 5.8,
        fearGreedAdj: 2.1,
        socialAdj: 1.8,
        breadthAdj: 0.5,
        volatilityAdj: -0.3,
        color: 'green',
        candleSize: 'long',
        topReason: 'Fed dovish signal + Middle East tension',
        fearGreedValue: 68,
      ),
      DailyImpact(
        asset: 'DXY',
        date: '2026-08-05',
        finalScore: -5.4,
        aiScore: -4.8,
        priceReaction: -3.9,
        fearGreedAdj: -1.2,
        socialAdj: -0.9,
        breadthAdj: -0.3,
        volatilityAdj: 0.4,
        color: 'red',
        candleSize: 'medium',
        topReason: 'Fed rate cut expectations',
        fearGreedValue: 68,
      ),
      DailyImpact(
        asset: 'US100',
        date: '2026-08-05',
        finalScore: 4.1,
        aiScore: 3.8,
        priceReaction: 4.2,
        fearGreedAdj: 1.5,
        socialAdj: 0.7,
        breadthAdj: 0.8,
        volatilityAdj: -1.1,
        color: 'green',
        candleSize: 'short',
        topReason: 'Tech earnings strong but VIX high',
        fearGreedValue: 68,
      ),
      DailyImpact(
        asset: 'US30',
        date: '2026-08-05',
        finalScore: 2.8,
        aiScore: 2.5,
        priceReaction: 3.1,
        fearGreedAdj: 1.2,
        socialAdj: 0.4,
        breadthAdj: 0.6,
        volatilityAdj: -0.8,
        color: 'green',
        candleSize: 'short',
        topReason: 'US economy resilient',
        fearGreedValue: 68,
      ),
      DailyImpact(
        asset: 'SP500',
        date: '2026-08-05',
        finalScore: 3.5,
        aiScore: 3.2,
        priceReaction: 3.8,
        fearGreedAdj: 1.4,
        socialAdj: 0.6,
        breadthAdj: 0.7,
        volatilityAdj: -0.9,
        color: 'green',
        candleSize: 'medium',
        topReason: 'Broad market rally',
        fearGreedValue: 68,
      ),
    ];
  }

  static DailyImpact getBestOpportunity() {
    final list = getTodayImpacts();
    return list.reduce((a, b) => a.finalScore.abs() > b.finalScore.abs() ? a : b);
  }

  static TradeSuggestion generateSuggestion(DailyImpact impact) {
    final score = impact.finalScore;
    String direction;
    String strength;
    String reason;

    if (score >= 6.5) {
      direction = 'Long';
      strength = 'Strong';
      reason = 'แท่งเขียวยาวชัดเจน ปัจจัยสนับสนุนหลายตัว';
    } else if (score >= 3.0) {
      direction = 'Long';
      strength = 'Moderate';
      reason = 'แนวโน้มบวก แต่ยังไม่แรงมาก';
    } else if (score <= -6.5) {
      direction = 'Short';
      strength = 'Strong';
      reason = 'แท่งแดงยาวชัดเจน มีแรงกดดันสูง';
    } else if (score <= -3.0) {
      direction = 'Short';
      strength = 'Moderate';
      reason = 'แนวโน้มลบ ระวังการกลับตัว';
    } else {
      direction = 'Neutral';
      strength = 'Caution';
      reason = 'สัญญาณยังไม่ชัดเจน แนะนำรอดูเพิ่ม';
    }

    return TradeSuggestion(
      asset: impact.asset,
      direction: direction,
      strength: strength,
      reason: reason,
      timeframe: 'Today',
      confidence: (score.abs() / 10).clamp(0.35, 0.95),
    );
  }

  static Map<String, dynamic> getWeeklyRecommendation() {
    return {
      'primary': {
        'asset': 'Gold',
        'direction': 'Long',
        'strength': 'Strong',
        'reason': 'แท่งเขียวต่อเนื่องหลายวัน + DXY อ่อนตัว',
        'confidence': 0.82,
      },
      'secondary': {
        'asset': 'DXY',
        'direction': 'Short',
        'strength': 'Moderate',
        'reason': 'แนวโน้มอ่อนตัวจากคาดการณ์ดอกเบี้ย Fed',
        'confidence': 0.71,
      },
      'avoid': {
        'asset': 'US100',
        'reason': 'Volatility สูงและสัญญาณยังสับสน',
      },
      'summary': 'สัปดาห์นี้แนะนำโฟกัส Long Gold เป็นหลัก',
    };
  }

  static List<HistoricalDay> getHistoricalData() {
    return [
      HistoricalDay(
        date: '2026-08-05',
        summary: 'Gold แข็งแกร่งจาก Fed dovish + ความตึงเครียดภูมิรัฐศาสตร์',
        impacts: getTodayImpacts(),
      ),
      HistoricalDay(
        date: '2026-08-04',
        summary: 'ตลาดพักฐาน DXY เริ่มอ่อนตัว',
        impacts: [
          DailyImpact(asset: 'Gold', date: '2026-08-04', finalScore: 3.8, aiScore: 3.2, priceReaction: 2.9, fearGreedAdj: 1.1, socialAdj: 0.8, breadthAdj: 0.4, volatilityAdj: -0.2, color: 'green', candleSize: 'short', topReason: 'Mild safe-haven demand', fearGreedValue: 62),
          DailyImpact(asset: 'DXY', date: '2026-08-04', finalScore: -2.1, aiScore: -1.8, priceReaction: -1.5, fearGreedAdj: -0.6, socialAdj: -0.4, breadthAdj: -0.2, volatilityAdj: 0.3, color: 'red', candleSize: 'short', topReason: 'USD softening', fearGreedValue: 62),
          DailyImpact(asset: 'US100', date: '2026-08-04', finalScore: 1.9, aiScore: 1.6, priceReaction: 2.2, fearGreedAdj: 0.7, socialAdj: 0.3, breadthAdj: 0.5, volatilityAdj: -0.5, color: 'green', candleSize: 'very_short', topReason: 'Tech consolidation', fearGreedValue: 62),
          DailyImpact(asset: 'US30', date: '2026-08-04', finalScore: 1.4, aiScore: 1.2, priceReaction: 1.8, fearGreedAdj: 0.5, socialAdj: 0.2, breadthAdj: 0.4, volatilityAdj: -0.4, color: 'green', candleSize: 'very_short', topReason: 'Mild positive', fearGreedValue: 62),
          DailyImpact(asset: 'SP500', date: '2026-08-04', finalScore: 1.7, aiScore: 1.4, priceReaction: 2.0, fearGreedAdj: 0.6, socialAdj: 0.3, breadthAdj: 0.4, volatilityAdj: -0.4, color: 'green', candleSize: 'very_short', topReason: 'Broad mild gain', fearGreedValue: 62),
        ],
      ),
    ];
  }

  static Future<ShockResult> simulateEventAI(String event) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/simulate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"event": event}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ShockResult(
          event: data["event"] ?? event,
          scores: Map<String, double>.from(
            (data["scores"] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
          ),
          reasons: Map<String, String>.from(
            (data["reasons"] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
          ),
          confidence: (data["confidence"] as num?)?.toDouble() ?? 0.75,
          summary: data["summary"] ?? "Simulated impact",
        );
      } else {
        return simulateEvent(event);
      }
    } catch (e) {
      return simulateEvent(event);
    }
  }

  static ShockResult simulateEvent(String event) {
    final lower = event.toLowerCase();
    Map<String, double> scores = {'Gold': 1.5, 'DXY': -0.8, 'US100': 1.2, 'US30': 1.0, 'SP500': 1.1};
    Map<String, String> reasons = {
      'Gold': 'ผลกระทบจำกัด',
      'DXY': 'ผลกระทบจำกัด',
      'US100': 'ผลกระทบจำกัด',
      'US30': 'ผลกระทบจำกัด',
      'SP500': 'ผลกระทบจำกัด',
    };

    if (lower.contains('fed') && (lower.contains('cut') || lower.contains('dovish'))) {
      scores = {'Gold': 7.8, 'DXY': -6.5, 'US100': 5.4, 'US30': 4.2, 'SP500': 4.8};
      reasons = {
        'Gold': 'ดอกเบี้ยต่ำหนุนทอง',
        'DXY': 'นโยบายผ่อนคลายกดดัน USD',
        'US100': 'สภาพคล่องเพิ่มขึ้นดีต่อเทค',
        'US30': 'สนับสนุนสินทรัพย์เสี่ยง',
        'SP500': 'ภาพรวมตลาดเป็นบวก',
      };
    } else if (lower.contains('war') || lower.contains('iran') || lower.contains('hormuz') || lower.contains('geopolit')) {
      scores = {'Gold': 8.6, 'DXY': 3.2, 'US100': -4.8, 'US30': -3.9, 'SP500': -4.3};
      reasons = {
        'Gold': 'Safe-haven แรงมาก',
        'DXY': 'USD แข็งจากความเสี่ยง',
        'US100': 'Risk-off กดดันหุ้นเทค',
        'US30': 'ความเสี่ยงภูมิรัฐศาสตร์',
        'SP500': 'ตลาดหุ้นปรับฐาน',
      };
    }

    return ShockResult(
      event: event,
      scores: scores,
      reasons: reasons,
      confidence: 0.72,
      summary: 'ผลการจำลองแบบ Offline',
    );
  }
}
