import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/announcement.dart';

final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('announcements')
      .select()
      .inFilter('target_role', ['all', 'student'])
      .eq('is_active', true)
      .order('created_at', ascending: false);
  return (response as List)
      .map((json) => Announcement.fromJson(json))
      .toList();
});
