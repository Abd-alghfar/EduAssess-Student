import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:CodeKey/core/network/supabase_client.dart';
import 'package:CodeKey/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:CodeKey/features/lessons/data/repositories/lesson_repository_impl.dart';

part 'lesson_repository_provider.g.dart';

@riverpod
LessonRepository lessonRepository(LessonRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return LessonRepositoryImpl(client);
}
