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
    const primaryColor = Color(0xFF005BD4); // Professional Security Blue
    const surfaceLight = Color(0xFFF8FAFC);
    const surfaceDark = Color(0xFF0F172A);

    return MaterialApp(
      title: 'Scam Message Detector',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Support both light and dark

      // ── Premium Light Theme ──
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: surfaceLight,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.light).textTheme,
        ).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
          bodyLarge: GoogleFonts.inter(color: const Color(0xFF334155)),
          bodyMedium: GoogleFonts.inter(color: const Color(0xFF475569)),
        ),
      ),

      // ── Premium Dark Theme ──
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: surfaceDark,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: const Color(0xFF1E293B),
          surfaceTintColor: const Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).copyWith(
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: GoogleFonts.inter(color: const Color(0xFFCBD5E1)),
          bodyMedium: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
        ),
      ),

      home: const ScamDetectorScreen(),
    );
  }
}
