import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_feedback.dart';

class LocalFeedbackStorageService {
  static const String _feedbackKey = 'scam_detector_feedback';
  static const String _weightsKey = 'scam_detector_adaptive_weights';

  Future<void> saveFeedback(UserFeedback feedback) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> current = prefs.getStringList(_feedbackKey) ?? [];
    current.add(jsonEncode(feedback.toJson()));
    await prefs.setStringList(_feedbackKey, current);
  }

  Future<Map<String, int>> getAdaptiveWeights() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString(_weightsKey);
    if (jsonStr == null) return {};
    
    final Map<String, dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  Future<void> saveAdaptiveWeights(Map<String, int> weights) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weightsKey, jsonEncode(weights));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_feedbackKey);
    await prefs.remove(_weightsKey);
  }
}
