import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/lesson.dart';
import 'lesson_repository_provider.dart';

part 'lessons_notifier.g.dart';

@riverpod
class LessonsNotifier extends _$LessonsNotifier {
  @override
  Future<List<Lesson>> build() async {
    return ref.read(lessonRepositoryProvider).getLessons();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(lessonRepositoryProvider).getLessons(),
    );
  }
}
