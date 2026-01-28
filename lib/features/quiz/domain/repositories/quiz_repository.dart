import '../entities/question.dart';
import '../entities/answer.dart';

abstract class QuizRepository {
  Future<List<Question>> getQuestions(String lessonId);
  Future<void> submitAnswer(Answer answer);
  Future<List<Answer>> getStudentAnswers(String lessonId, String userId);
  Future<Map<String, dynamic>> getLessonProgress(
    String lessonId,
    String userId,
  );
  Future<void> completeLesson(String lessonId, String userId, int totalScore);
}
