import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessons();
  Future<Map<String, Map<String, int>>> getLessonProgressMap(String userId);
}
