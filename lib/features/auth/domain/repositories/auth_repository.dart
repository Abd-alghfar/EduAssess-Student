import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signIn(String username, String accessKey);
  Future<void> signOut();
  Future<AppUser?> getPersistedUser();
}
