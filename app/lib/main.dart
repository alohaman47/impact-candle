import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const ImpactCandleApp());
}

class ImpactCandleApp extends StatelessWidget {
  const ImpactCandleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact Candle',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
