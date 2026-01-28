import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:abdotest/core/network/supabase_client.dart';
import 'package:abdotest/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:abdotest/features/lessons/data/repositories/lesson_repository_impl.dart';

part 'lesson_repository_provider.g.dart';

@riverpod
LessonRepository lessonRepository(LessonRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return LessonRepositoryImpl(client);
}
