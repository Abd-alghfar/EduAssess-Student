import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/core/network/supabase_client.dart';
import 'package:eduassess_student/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:eduassess_student/features/quiz/data/repositories/quiz_repository_impl.dart';

part 'quiz_repository_provider.g.dart';

@riverpod
QuizRepository quizRepository(QuizRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return QuizRepositoryImpl(client);
}
