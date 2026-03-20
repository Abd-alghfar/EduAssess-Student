import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final SupabaseClient _client;

  LessonRepositoryImpl(this._client);

  @override
  Future<List<Lesson>> getLessons(String userId) async {
    final classIds = await _getStudentClassIds(userId);
    print('[Lessons] class ids: ${classIds.length}');
    if (classIds.isEmpty) {
      return [];
    }

    final assignmentIds = await _getAssignmentIdsForClasses(classIds);
    print('[Lessons] assignment ids: ${assignmentIds.length}');
    if (assignmentIds.isEmpty) {
      return [];
    }

    final response = await _client
        .from('lessons')
        .select()
        .inFilter('assignment_id', assignmentIds)
        .order('created_at', ascending: true);

    final rows = (response as List);
    print('[Lessons] raw rows: ${rows.length}');
    final List<Lesson> lessons = [];
    for (final row in rows) {
      try {
        lessons.add(Lesson.fromJson(row));
      } catch (e) {
        final id = row is Map ? row['id'] : null;
        print('[Lessons] parse error for id=$id: $e');
      }
    }
    print('[Lessons] parsed lessons: ${lessons.length}');
    return lessons;
  }

  @override
  Future<Map<String, Map<String, int>>> getLessonProgressMap(
    String userId,
  ) async {
    final classIds = await _getStudentClassIds(userId);
    print('[Progress] class ids: ${classIds.length}');
    if (classIds.isEmpty) {
      return {};
    }
    final assignmentIds = await _getAssignmentIdsForClasses(classIds);
    print('[Progress] assignment ids: ${assignmentIds.length}');
    if (assignmentIds.isEmpty) {
      return {};
    }
    final lessonIds = await _getLessonIdsForAssignments(assignmentIds);
    print('[Progress] lesson ids: ${lessonIds.length}');
    if (lessonIds.isEmpty) {
      return {};
    }

    // 1. Get completed attempts
    final progressResponse = await _client
        .from('exam_attempts')
        .select('lesson_id, score')
        .eq('student_id', userId)
        .eq('is_completed', true)
        .inFilter('lesson_id', lessonIds);
    print('[Progress] attempts rows: ${(progressResponse as List).length}');

    // 2. Get total possible points for all lessons
    final questionsResponse = await _client
        .from('questions')
        .select('lesson_id, points')
        .inFilter('lesson_id', lessonIds);
    print('[Progress] questions rows: ${(questionsResponse as List).length}');

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

  Future<List<String>> _getStudentClassIds(String userId) async {
    final response = await _client
        .from('class_students')
        .select('class_id')
        .eq('student_id', userId);

    return (response as List)
        .map((row) => row['class_id'] as String)
        .toList();
  }

  Future<List<String>> _getAssignmentIdsForClasses(
    List<String> classIds,
  ) async {
    final response = await _client
        .from('teacher_assignments')
        .select('id')
        .inFilter('class_id', classIds)
        .eq('is_active', true);

    return (response as List).map((row) => row['id'] as String).toList();
  }

  Future<List<String>> _getLessonIdsForAssignments(
    List<String> assignmentIds,
  ) async {
    final response = await _client
        .from('lessons')
        .select('id')
        .inFilter('assignment_id', assignmentIds)
        .eq('is_published', true);

    return (response as List).map((row) => row['id'] as String).toList();
  }

  

}
