import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:abdotest/core/network/supabase_client.dart';
import 'package:abdotest/features/auth/domain/repositories/auth_repository.dart';
import 'package:abdotest/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
}
