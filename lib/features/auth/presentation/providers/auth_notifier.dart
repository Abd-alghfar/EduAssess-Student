import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/auth_repository_provider.dart';
import '../../domain/entities/app_user.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AppUser? build() {
    _init();
    return null;
  }

  Future<void> _init() async {
    final user = await ref.read(authRepositoryProvider).getPersistedUser();
    state = user;
  }

  Future<void> signIn(String username, String accessKey) async {
    final user = await ref
        .read(authRepositoryProvider)
        .signIn(username, accessKey);
    state = user;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = null;
  }
}
