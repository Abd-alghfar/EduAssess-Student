import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/features/auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/lesson.dart';
import 'lesson_repository_provider.dart';

part 'lessons_notifier.g.dart';

@riverpod
class LessonsNotifier extends _$LessonsNotifier {
  @override
  Future<List<Lesson>> build() async {
    final user = ref.watch(authNotifierProvider);
    if (user == null) return [];
    return ref.read(lessonRepositoryProvider).getLessons(user.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () {
        final user = ref.read(authNotifierProvider);
        if (user == null) return Future.value(<Lesson>[]);
        return ref.read(lessonRepositoryProvider).getLessons(user.id);
      },
    );
  }
}
