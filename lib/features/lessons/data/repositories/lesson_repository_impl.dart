import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final SupabaseClient _client;

  LessonRepositoryImpl(this._client);

  @override
  Future<List<Lesson>> getLessons() async {
    final response = await _client
        .from('lessons')
        .select()
        .order('created_at', ascending: true);

    return (response as List).map((json) => Lesson.fromJson(json)).toList();
  }

  @override
  Future<Map<String, Map<String, int>>> getLessonProgressMap(
    String userId,
  ) async {
    // 1. Get completed attempts
    final progressResponse = await _client
        .from('exam_attempts')
        .select('lesson_id, score')
        .eq('student_id', userId)
        .eq('is_completed', true);

    // 2. Get total possible points for all lessons
    final questionsResponse = await _client
        .from('questions')
        .select('lesson_id, points');

    final Map<String, int> totalPointsMap = {};
    for (final q in (questionsResponse as List)) {
      final lessonId = q['lesson_id'] as String;
      final points = q['points'] as int;
      totalPointsMap[lessonId] = (totalPointsMap[lessonId] ?? 0) + points;
    }

    final Map<String, Map<String, int>> resultMap = {};
    for (final item in (progressResponse as List)) {
      final lessonId = item['lesson_id'] as String;
      final score = (item['score'] ?? 0).toDouble();
      final existing = resultMap[lessonId]?['attained'] ?? 0;
      final best = score.round() > existing ? score.round() : existing;
      resultMap[lessonId] = {
        'attained': best,
        'total': totalPointsMap[lessonId] ?? 0,
      };
    }
    return resultMap;
  }
}
