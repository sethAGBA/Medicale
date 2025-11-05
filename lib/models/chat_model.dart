class ChatModel {
  final String id;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.id,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      id: data['id'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(data['lastMessageTime'] ?? DateTime.now().toIso8601String()),
    );
  }
} 