/// Spaced repetition Leitner interval stages (Box 1 to Box 5).
enum SpacedRepetitionLevel {
  box1(intervalDays: 1, label: 'Initial Review (Day 1)'),
  box2(intervalDays: 3, label: 'Short-Term Anchor (Day 3)'),
  box3(intervalDays: 7, label: 'Weekly Consolidation (Day 7)'),
  box4(intervalDays: 14, label: 'Bi-Weekly Retention (Day 14)'),
  box5(intervalDays: 30, label: 'Mastery Review (Day 30)');

  const SpacedRepetitionLevel({
    required this.intervalDays,
    required this.label,
  });

  final int intervalDays;
  final String label;

  /// Advances to next Leitner interval box upon successful recall.
  SpacedRepetitionLevel get next {
    switch (this) {
      case SpacedRepetitionLevel.box1:
        return SpacedRepetitionLevel.box2;
      case SpacedRepetitionLevel.box2:
        return SpacedRepetitionLevel.box3;
      case SpacedRepetitionLevel.box3:
        return SpacedRepetitionLevel.box4;
      case SpacedRepetitionLevel.box4:
      case SpacedRepetitionLevel.box5:
        return SpacedRepetitionLevel.box5;
    }
  }

  /// Resets to Box 1 if student struggles or forgets.
  SpacedRepetitionLevel get reset => SpacedRepetitionLevel.box1;

  String toStorageKey() => name;

  static SpacedRepetitionLevel fromString(String? key) {
    if (key == null) return SpacedRepetitionLevel.box1;
    return SpacedRepetitionLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == key.toLowerCase(),
      orElse: () => SpacedRepetitionLevel.box1,
    );
  }
}

/// Model representing a scheduled spaced-repetition study review session for an exam topic.
class ReviewSession {
  const ReviewSession({
    this.id,
    this.examTargetId,
    required this.topic,
    this.level = SpacedRepetitionLevel.box1,
    required this.nextReviewDate,
    this.lastReviewedAt,
    this.isCompleted = false,
    required this.createdAt,
  });

  final int? id;
  final int? examTargetId;
  final String topic;
  final SpacedRepetitionLevel level;
  final DateTime nextReviewDate;
  final DateTime? lastReviewedAt;
  final bool isCompleted;
  final DateTime createdAt;

  /// Returns true if this review is due today or overdue.
  bool get isDue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return nextReviewDate.isBefore(endOfToday);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (examTargetId != null) 'exam_target_id': examTargetId,
      'topic': topic,
      'level': level.toStorageKey(),
      'next_review_date': nextReviewDate.toIso8601String(),
      'last_reviewed_at': lastReviewedAt?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReviewSession.fromJson(Map<String, dynamic> json) {
    return ReviewSession(
      id: json['id'] as int?,
      examTargetId: json['exam_target_id'] as int?,
      topic: json['topic'] as String,
      level: SpacedRepetitionLevel.fromString(json['level'] as String?),
      nextReviewDate: DateTime.parse(json['next_review_date'] as String),
      lastReviewedAt: json['last_reviewed_at'] != null
          ? DateTime.parse(json['last_reviewed_at'] as String)
          : null,
      isCompleted: (json['is_completed'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ReviewSession copyWith({
    int? id,
    int? examTargetId,
    String? topic,
    SpacedRepetitionLevel? level,
    DateTime? nextReviewDate,
    DateTime? lastReviewedAt,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return ReviewSession(
      id: id ?? this.id,
      examTargetId: examTargetId ?? this.examTargetId,
      topic: topic ?? this.topic,
      level: level ?? this.level,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
