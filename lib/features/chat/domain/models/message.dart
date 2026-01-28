class ChatMessage {
  final String id;
  final String senderId;
  final String? content;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.content,
    this.imageUrl,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      content: json['content'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'sender_id': senderId, 'content': content, 'image_url': imageUrl};
  }
}
