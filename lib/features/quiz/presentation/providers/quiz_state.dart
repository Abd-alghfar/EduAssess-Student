import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/question.dart';

part 'quiz_state.freezed.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    @Default([]) List<Question> questions,
    @Default(0) int currentIndex,
    @Default(false) bool isLoading,
    String? error,
    @Default(false) bool isCompleted,
    @Default({}) Map<String, dynamic> answers,
    @Default(false) bool isCurrentQuestionAnswered,
    bool? isCurrentQuestionCorrect,
    dynamic currentCorrectAnswer,
    int? remainingSeconds,
    @Default(true) bool showCorrection,
  }) = _QuizState;
}
