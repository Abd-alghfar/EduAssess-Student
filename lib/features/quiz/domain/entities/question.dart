// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

enum QuestionType {
  @JsonValue('mcq')
  mcq,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('true_false')
  trueFalse,
  @JsonValue('essay')
  essay,
  @JsonValue('code')
  code,
  @JsonValue('code_completion')
  codeCompletion,
}

@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'question_type') required QuestionType questionType,
    @Default({}) Map<String, dynamic> config,
    @Default(1) int points,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
