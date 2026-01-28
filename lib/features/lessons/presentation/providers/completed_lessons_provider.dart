import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'lesson_repository_provider.dart';
import 'package:abdotest/features/auth/presentation/providers/auth_notifier.dart';

part 'completed_lessons_provider.g.dart';

@riverpod
Future<Map<String, Map<String, int>>> lessonProgress(
  LessonProgressRef ref,
) async {
  final user = ref.watch(authNotifierProvider);
  if (user == null) return {};

  return ref.read(lessonRepositoryProvider).getLessonProgressMap(user.id);
}
