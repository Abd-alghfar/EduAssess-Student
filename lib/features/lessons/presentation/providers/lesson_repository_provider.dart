import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/core/network/supabase_client.dart';
import 'package:eduassess_student/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:eduassess_student/features/lessons/data/repositories/lesson_repository_impl.dart';

part 'lesson_repository_provider.g.dart';

@riverpod
LessonRepository lessonRepository(LessonRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return LessonRepositoryImpl(client);
}
