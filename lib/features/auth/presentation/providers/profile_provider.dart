import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eduassess_student/core/network/supabase_client.dart';
import 'package:eduassess_student/features/auth/presentation/providers/auth_notifier.dart';

part 'profile_provider.g.dart';

@riverpod
Future<Map<String, dynamic>?> userProfile(UserProfileRef ref) async {
  final user = ref.watch(authNotifierProvider);
  if (user == null) return null;

  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('profiles')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  return response;
}
