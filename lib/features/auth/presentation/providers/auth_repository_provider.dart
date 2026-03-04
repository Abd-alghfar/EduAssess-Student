import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/core/network/supabase_client.dart';
import 'package:eduassess_student/features/auth/domain/repositories/auth_repository.dart';
import 'package:eduassess_student/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
}
