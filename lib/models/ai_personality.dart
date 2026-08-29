/// Supported AI assistant personality tones for personalized schedule and nudge generation.
enum AiPersonality {
  encouragingMentor,
  strictCoach,
  minimalist;

  /// User-facing display title.
  String get displayName {
    switch (this) {
      case AiPersonality.encouragingMentor:
        return 'Encouraging Mentor';
      case AiPersonality.strictCoach:
        return 'Strict Coach';
      case AiPersonality.minimalist:
        return 'Minimalist';
    }
  }

  /// User-facing description of tone behavior.
  String get description {
    switch (this) {
      case AiPersonality.encouragingMentor:
        return 'Warm, supportive, and celebratory. Focuses on positive reinforcement.';
      case AiPersonality.strictCoach:
        return 'Direct, disciplined, and urgent. Holds you strictly accountable with zero excuses.';
      case AiPersonality.minimalist:
        return 'Ultra-concise and distraction-free. Delivers only essential actions and zero fluff.';
    }
  }

  /// System prompt directive injected into Gemini generative tasks.
  String get promptDirective {
    switch (this) {
      case AiPersonality.encouragingMentor:
        return 'Tone: Warm, empathetic, and encouraging. Use positive reinforcement and celebrate wins.';
      case AiPersonality.strictCoach:
        return 'Tone: Direct, disciplined, and urgent. Challenge the student, emphasize deadlines, and allow no excuses.';
      case AiPersonality.minimalist:
        return 'Tone: Minimalist and ultra-concise. Use brief phrases with zero filler words or fluff.';
    }
  }

  /// Parses an [AiPersonality] from a stored string value with fallback to [encouragingMentor].
  static AiPersonality fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'strict_coach':
      case 'strictcoach':
        return AiPersonality.strictCoach;
      case 'minimalist':
        return AiPersonality.minimalist;
      case 'encouraging_mentor':
      case 'encouragingmentor':
      default:
        return AiPersonality.encouragingMentor;
    }
  }

  /// Converts personality to a snake_case key for persistence.
  String toStorageKey() {
    switch (this) {
      case AiPersonality.encouragingMentor:
        return 'encouraging_mentor';
      case AiPersonality.strictCoach:
        return 'strict_coach';
      case AiPersonality.minimalist:
        return 'minimalist';
    }
  }
}
