import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ai_personality.dart';
import '../utils/constants.dart';
import 'gemini_service.dart';

/// Gemini API key — injected via --dart-define at build time.
/// Never hardcoded. Falls back to empty string (service will fail gracefully).
const String _geminiApiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);

/// Provider for the GeminiService singleton.
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(apiKey: _geminiApiKey);
});

/// StateNotifier for the user's selected AI personality with SharedPreferences persistence.
class AiPersonalityNotifier extends StateNotifier<AiPersonality> {
  AiPersonalityNotifier() : super(AiPersonality.encouragingMentor) {
    _loadPersonality();
  }

  Future<void> _loadPersonality() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedKey = prefs.getString(kPrefAiPersonality);
      if (savedKey != null) {
        state = AiPersonality.fromString(savedKey);
      }
    } catch (_) {
      // Fall back to default state
    }
  }

  Future<void> setPersonality(AiPersonality personality) async {
    state = personality;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kPrefAiPersonality, personality.toStorageKey());
    } catch (_) {}
  }
}

/// Provider managing active AI personality tone.
final aiPersonalityProvider =
    StateNotifierProvider<AiPersonalityNotifier, AiPersonality>((ref) {
  return AiPersonalityNotifier();
});
