import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:abdotest/features/auth/presentation/providers/auth_notifier.dart';
import '../../domain/models/message.dart';

final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  final supabase = Supabase.instance.client;
  final user = ref.watch(authNotifierProvider);

  if (user == null) return Stream.value([]);

  return supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('sender_id', user.id)
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => ChatMessage.fromJson(json)).toList());
});

final chatNotifierProvider = Provider((ref) {
  final user = ref.watch(authNotifierProvider);
  return ChatNotifier(user?.id);
});

class ChatNotifier {
  final String? _currentUserId;
  final supabase = Supabase.instance.client;

  ChatNotifier(this._currentUserId);

  Future<void> sendMessage(String text, {File? imageFile}) async {
    final userId = _currentUserId;
    if (userId == null) return;

    String? imageUrl;

    if (imageFile != null) {
      try {
        final fileName = 'chat_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'uploads/$userId/$fileName';

        await supabase.storage.from('chat_images').upload(path, imageFile);
        imageUrl = supabase.storage.from('chat_images').getPublicUrl(path);
      } catch (e) {
        rethrow;
      }
    }

    if (text.trim().isNotEmpty || imageUrl != null) {
      try {
        await supabase.from('messages').insert({
          'sender_id': userId,
          'content': text.trim().isEmpty ? null : text.trim(),
          'image_url': imageUrl,
        });
      } catch (e) {
        rethrow;
      }
    }
  }
}
