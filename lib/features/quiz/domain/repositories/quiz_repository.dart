import '../entities/question.dart';
import '../entities/answer.dart';

abstract class QuizRepository {
  Future<List<Question>> getQuestions(String lessonId);
  Future<String> getOrCreateAttempt(String lessonId, String userId);
  Future<List<Answer>> getAttemptAnswers(String attemptId);
  Future<void> submitAnswer(String attemptId, Answer answer);
  Future<Map<String, dynamic>?> getLatestAttempt(
    String lessonId,
    String userId,
  );
  Future<void> completeAttempt(String attemptId, int totalScore);
}
