// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

@freezed
class Answer with _$Answer {
  const factory Answer({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'answer_value') required dynamic answerValue,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'score_attained') @Default(0) int scoreAttained,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Answer;

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
