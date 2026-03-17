// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'show_correction') @Default(true) bool showCorrection,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'scheduled_at') DateTime? scheduledAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
