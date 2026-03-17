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
  Future<String> getOrCreateAttempt(String lessonId, String userId) async {
    final existing = await getLatestAttempt(lessonId, userId);
    if (existing != null && existing['is_completed'] == false) {
      return existing['id'];
    }
    if (existing != null && existing['is_completed'] == true) {
      return existing['id'];
    }
    final response = await _client
        .from('exam_attempts')
        .insert({
          'student_id': userId,
          'lesson_id': lessonId,
          'is_completed': false,
          'started_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();
    return response['id'];
  }

  @override
  Future<List<Answer>> getAttemptAnswers(String attemptId) async {
    final response = await _client
        .from('student_answers')
        .select()
        .eq('attempt_id', attemptId);

    return (response as List).map((json) {
      return Answer.fromJson({
        'id': json['id'],
        'student_id': '',
        'question_id': json['question_id'],
        'answer_value': json['student_answer'],
        'is_correct': json['is_correct'],
        'score_attained': json['points_earned'] ?? 0,
        'created_at': json['created_at'] ?? DateTime.now().toIso8601String(),
      });
    }).toList();
  }

  @override
  Future<void> submitAnswer(String attemptId, Answer answer) async {
    final existing = await _client
        .from('student_answers')
        .select('id')
        .eq('attempt_id', attemptId)
        .eq('question_id', answer.questionId)
        .maybeSingle();

    final payload = {
      'attempt_id': attemptId,
      'question_id': answer.questionId,
      'student_answer': answer.answerValue,
      'is_correct': answer.isCorrect,
      'points_earned': answer.scoreAttained,
    };

    if (existing != null) {
      await _client
          .from('student_answers')
          .update(payload)
          .eq('id', existing['id']);
    } else {
      await _client.from('student_answers').insert(payload);
    }
  }

  @override
  Future<Map<String, dynamic>?> getLatestAttempt(
    String lessonId,
    String userId,
  ) async {
    final response = await _client
        .from('exam_attempts')
        .select()
        .eq('student_id', userId)
        .eq('lesson_id', lessonId)
        .order('started_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return response;
  }

  @override
  Future<void> completeAttempt(String attemptId, int totalScore) async {
    await _client
        .from('exam_attempts')
        .update({
          'score': totalScore,
          'is_completed': true,
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', attemptId);
  }
}
