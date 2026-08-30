/// Model representing a semester exam, unit test, or competitive examination target.
class ExamTarget {
  const ExamTarget({
    this.id,
    required this.subject,
    required this.examDate,
    this.targetScore = 100.0,
    this.syllabusTopics = const [],
    this.completedTopicsCount = 0,
    this.roomOrLocation,
    required this.createdAt,
  });

  final int? id;
  final String subject;
  final DateTime examDate;
  final double targetScore;
  final List<String> syllabusTopics;
  final int completedTopicsCount;
  final String? roomOrLocation;
  final DateTime createdAt;

  /// Returns the number of whole days remaining until the examination.
  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final examDay = DateTime(examDate.year, examDate.month, examDate.day);
    return examDay.difference(today).inDays;
  }

  /// Returns true if the exam is within the critical crunch window (<= 7 days).
  bool get isCrunchTime => daysRemaining <= 7 && daysRemaining >= 0;

  /// Returns true if the exam has already passed.
  bool get isPast => daysRemaining < 0;

  /// Returns completion fraction between 0.0 and 1.0.
  double get syllabusProgress {
    if (syllabusTopics.isEmpty) return 0.0;
    return (completedTopicsCount / syllabusTopics.length).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subject': subject,
      'exam_date': examDate.toIso8601String(),
      'target_score': targetScore,
      'syllabus_topics': syllabusTopics.join(';'),
      'completed_topics_count': completedTopicsCount,
      'room_or_location': roomOrLocation,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ExamTarget.fromJson(Map<String, dynamic> json) {
    final rawTopics = json['syllabus_topics'] as String? ?? '';
    final topics = rawTopics.isEmpty
        ? <String>[]
        : rawTopics.split(';').where((t) => t.trim().isNotEmpty).toList();

    return ExamTarget(
      id: json['id'] as int?,
      subject: json['subject'] as String,
      examDate: DateTime.parse(json['exam_date'] as String),
      targetScore: (json['target_score'] as num?)?.toDouble() ?? 100.0,
      syllabusTopics: topics,
      completedTopicsCount: json['completed_topics_count'] as int? ?? 0,
      roomOrLocation: json['room_or_location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ExamTarget copyWith({
    int? id,
    String? subject,
    DateTime? examDate,
    double? targetScore,
    List<String>? syllabusTopics,
    int? completedTopicsCount,
    String? roomOrLocation,
    DateTime? createdAt,
  }) {
    return ExamTarget(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      examDate: examDate ?? this.examDate,
      targetScore: targetScore ?? this.targetScore,
      syllabusTopics: syllabusTopics ?? this.syllabusTopics,
      completedTopicsCount: completedTopicsCount ?? this.completedTopicsCount,
      roomOrLocation: roomOrLocation ?? this.roomOrLocation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
