import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:abdotest/features/quiz/domain/entities/answer.dart';
import 'package:abdotest/features/quiz/domain/entities/question.dart';
import 'package:abdotest/features/quiz/presentation/providers/quiz_repository_provider.dart';
import 'package:abdotest/features/quiz/presentation/providers/quiz_state.dart';
import 'package:abdotest/features/auth/presentation/providers/auth_notifier.dart';
import 'package:abdotest/features/lessons/presentation/providers/lesson_repository_provider.dart';
import 'dart:async';

part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  Timer? _timer;

  @override
  QuizState build(String lessonId) {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _loadQuestions();
    return const QuizState(isLoading: true);
  }

  Future<void> _loadQuestions() async {
    try {
      final user = ref.read(authNotifierProvider);
      if (user == null) return;

      final repository = ref.read(quizRepositoryProvider);
      final lessonRepo = ref.read(lessonRepositoryProvider);

      final questions = await repository.getQuestions(lessonId);
      final lessons = await lessonRepo.getLessons();
      final lesson = lessons.firstWhere((l) => l.id == lessonId);

      final studentAnswers = await repository.getStudentAnswers(
        lessonId,
        user.id,
      );

      final progress = await repository.getLessonProgress(lessonId, user.id);
      final bool alreadyCompleted =
          progress['id'] != null || progress['completed_at'] != null;

      final answersMap = <String, dynamic>{};
      for (final answer in studentAnswers) {
        answersMap[answer.questionId] = answer.answerValue;
      }

      state = state.copyWith(
        questions: questions,
        answers: answersMap,
        isLoading: false,
        isCompleted: alreadyCompleted,
        remainingSeconds: lesson.durationMinutes != null
            ? lesson.durationMinutes! * 60
            : null,
      );

      // Only start timer if NOT already completed
      if (!alreadyCompleted &&
          state.remainingSeconds != null &&
          state.remainingSeconds! > 0) {
        _startTimer();
      }

      _updateCurrentQuestionStatus();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void _updateCurrentQuestionStatus() {
    if (state.questions.isEmpty) return;

    final currentQuestion = state.questions[state.currentIndex];
    final existingAnswer = state.answers[currentQuestion.id];

    if (existingAnswer != null) {
      final isCorrect = _checkAnswer(currentQuestion, existingAnswer);
      state = state.copyWith(
        isCurrentQuestionAnswered: true,
        isCurrentQuestionCorrect: isCorrect,
        currentCorrectAnswer: currentQuestion.config['correct_answer'],
      );
    } else {
      state = state.copyWith(
        isCurrentQuestionAnswered: false,
        isCurrentQuestionCorrect: null,
        currentCorrectAnswer: null,
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds == null || state.remainingSeconds! <= 0) {
        timer.cancel();
        _finishQuiz();
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds! - 1);
      }
    });
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    // Calculate attained points based on correct answers
    int attainedPoints = 0;
    for (final question in state.questions) {
      final answer = state.answers[question.id];
      if (answer != null && _checkAnswer(question, answer)) {
        attainedPoints += question.points;
      }
    }

    try {
      final user = ref.read(authNotifierProvider);
      if (user != null) {
        await ref
            .read(quizRepositoryProvider)
            .completeLesson(lessonId, user.id, attainedPoints);
      }
    } catch (e) {
      // Log error but complete the quiz anyway
    }

    state = state.copyWith(isCompleted: true);
  }

  Future<void> nextQuestion() async {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      _updateCurrentQuestionStatus();
    } else {
      await _finishQuiz();
    }
  }

  Future<void> submitAnswer(dynamic value) async {
    if (state.isCurrentQuestionAnswered || state.isCompleted) return;

    final question = state.questions[state.currentIndex];
    final user = ref.read(authNotifierProvider);
    final userId = user?.id;

    if (userId == null) return;

    bool isCorrect = _checkAnswer(question, value);
    int score = isCorrect ? question.points : 0;

    final answer = Answer(
      id: '',
      studentId: userId,
      questionId: question.id,
      answerValue: value,
      isCorrect: isCorrect,
      scoreAttained: score,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(quizRepositoryProvider).submitAnswer(answer);
      final newAnswers = Map<String, dynamic>.from(state.answers);
      newAnswers[question.id] = value;

      state = state.copyWith(
        answers: newAnswers,
        isCurrentQuestionAnswered: true,
        isCurrentQuestionCorrect: isCorrect,
        currentCorrectAnswer: question.config['correct_answer'],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  bool _checkAnswer(Question question, dynamic value) {
    final correctAnswer = question.config['correct_answer'];
    if (correctAnswer == null) return false;

    final userVal = value.toString().trim().toLowerCase();
    final correctVal = correctAnswer.toString().trim().toLowerCase();

    return userVal == correctVal;
  }
}
