import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/scam_detector_screen.dart';
import 'viewmodels/scam_detector_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScamDetectorViewModel(),
      child: const ScamDetectorApp(),
    ),
  );
}

class ScamDetectorApp extends StatelessWidget {
  const ScamDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Message Detector',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // Preferred for the "White Card" aesthetic

      // ── Premium Light Theme ──
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFF4F46E5), // Indigo primary
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.light).textTheme,
        ).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          headlineSmall: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),

      // ── Premium Dark Theme ──
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF818CF8),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          headlineSmall: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),

      home: const ScamDetectorScreen(),
    );
  }
}
