import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/features/quiz/domain/entities/answer.dart';
import 'package:eduassess_student/features/quiz/domain/entities/question.dart';
import 'package:eduassess_student/features/quiz/presentation/providers/quiz_repository_provider.dart';
import 'package:eduassess_student/features/quiz/presentation/providers/quiz_state.dart';
import 'package:eduassess_student/features/auth/presentation/providers/auth_notifier.dart';
import 'package:eduassess_student/features/lessons/presentation/providers/lesson_repository_provider.dart';
import 'package:eduassess_student/core/error/failure.dart';
import 'dart:async';

part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  Timer? _timer;
  String? _attemptId;

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

      // Check if not started yet
      final now = DateTime.now();
      if (lesson.scheduledAt != null && now.isBefore(lesson.scheduledAt!)) {
        throw 'العام لم يبدأ بعد. سيكون متاحاً في تمام الساعة ${lesson.scheduledAt!.hour}:${lesson.scheduledAt!.minute.toString().padLeft(2, '0')}';
      }

      // Check if expired
      if (lesson.expiresAt != null && now.isAfter(lesson.expiresAt!)) {
        throw 'عذراً، انتهى الوقت المخصص لهذا الاختبار ولم يعد متاحاً.';
      }

      final latestAttempt = await repository.getLatestAttempt(
        lessonId,
        user.id,
      );
      final bool alreadyCompleted = latestAttempt?['is_completed'] == true;
      _attemptId = await repository.getOrCreateAttempt(lessonId, user.id);

      final studentAnswers = await repository.getAttemptAnswers(_attemptId!);

      final answersMap = <String, dynamic>{};
      for (final answer in studentAnswers) {
        answersMap[answer.questionId] = answer.answerValue;
      }

      state = state.copyWith(
        questions: questions,
        answers: answersMap,
        isLoading: false,
        isCompleted: alreadyCompleted,
        showCorrection: lesson.showCorrection,
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
        currentCorrectAnswer: _formatCorrectAnswer(currentQuestion),
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
      if (user != null && _attemptId != null) {
        await ref
            .read(quizRepositoryProvider)
            .completeAttempt(_attemptId!, attainedPoints);
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
      if (_attemptId == null) {
        _attemptId = await ref
            .read(quizRepositoryProvider)
            .getOrCreateAttempt(lessonId, userId);
      }
      await ref.read(quizRepositoryProvider).submitAnswer(_attemptId!, answer);
      final newAnswers = Map<String, dynamic>.from(state.answers);
      newAnswers[question.id] = value;

      state = state.copyWith(
        answers: newAnswers,
        isCurrentQuestionAnswered: true,
        isCurrentQuestionCorrect: isCorrect,
        currentCorrectAnswer: _formatCorrectAnswer(question),
      );
    } catch (e) {
      state = state.copyWith(error: Failure.getFriendlyMessage(e));
    }
  }

  bool _checkAnswer(Question question, dynamic value) {
    switch (question.questionType) {
      case QuestionType.mcq:
      case QuestionType.trueFalse:
      case QuestionType.completion:
      case QuestionType.code:
      case QuestionType.codeCompletion:
      case QuestionType.essay:
        final correctAnswer = question.config['correct_answer'];
        if (correctAnswer == null) return false;
        return value.toString().trim().toLowerCase() ==
            correctAnswer.toString().trim().toLowerCase();
      case QuestionType.multiSelect:
        final correct = List<String>.from(
          question.config['correct_answers'] ?? [],
        );
        final user = (value as List?)?.map((e) => e.toString()).toList() ?? [];
        if (correct.length != user.length) return false;
        final norm = correct.map((e) => e.toLowerCase()).toSet();
        final userNorm = user.map((e) => e.toLowerCase()).toSet();
        return norm.length == userNorm.length && norm.containsAll(userNorm);
      case QuestionType.matching:
      case QuestionType.ordering:
        return false;
    }
  }

  String _formatCorrectAnswer(Question question) {
    switch (question.questionType) {
      case QuestionType.multiSelect:
        return (question.config['correct_answers'] as List? ?? [])
            .join(', ');
      case QuestionType.matching:
      case QuestionType.ordering:
        return '';
      default:
        return question.config['correct_answer']?.toString() ?? '';
    }
  }
}
