import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/gemini_service.dart';

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
