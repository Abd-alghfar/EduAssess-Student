import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/answer.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final SupabaseClient _client;

  QuizRepositoryImpl(this._client);

  @override
  Future<List<Question>> getQuestions(String lessonId) async {
    final response = await _client
        .from('questions')
        .select()
        .eq('lesson_id', lessonId);

    return (response as List).map((json) => Question.fromJson(json)).toList();
  }

  @override
  Future<void> submitAnswer(Answer answer) async {
    await _client.from('student_answers').upsert({
      'student_id': answer.studentId,
      'question_id': answer.questionId,
      'answer_value': answer.answerValue,
      'is_correct': answer.isCorrect,
      'score_attained': answer.scoreAttained,
    }, onConflict: 'student_id,question_id');
  }

  @override
  Future<List<Answer>> getStudentAnswers(String lessonId, String userId) async {
    // First get question IDs for this lesson
    final questionsResponse = await _client
        .from('questions')
        .select('id')
        .eq('lesson_id', lessonId);

    final questionIds = (questionsResponse as List)
        .map((q) => q['id'])
        .toList();
    if (questionIds.isEmpty) return [];

    final response = await _client
        .from('student_answers')
        .select()
        .eq('student_id', userId)
        .inFilter('question_id', questionIds);

    return (response as List).map((json) => Answer.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getLessonProgress(
    String lessonId,
    String userId,
  ) async {
    final response = await _client
        .from('student_progress')
        .select()
        .eq('student_id', userId)
        .eq('lesson_id', lessonId)
        .maybeSingle();

    return response ?? {'total_score': 0};
  }

  @override
  Future<void> completeLesson(
    String lessonId,
    String userId,
    int totalScore,
  ) async {
    await _client.from('student_progress').upsert({
      'student_id': userId,
      'lesson_id': lessonId,
      'total_score': totalScore,
      'completed_at': DateTime.now().toIso8601String(),
    }, onConflict: 'student_id,lesson_id');
  }
}
