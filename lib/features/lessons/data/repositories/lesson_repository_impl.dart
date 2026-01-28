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
    // 1. Get attained scores
    final progressResponse = await _client
        .from('student_progress')
        .select('lesson_id, total_score')
        .eq('student_id', userId);

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
      resultMap[lessonId] = {
        'attained': item['total_score'] as int,
        'total': totalPointsMap[lessonId] ?? 0,
      };
    }
    return resultMap;
  }
}
