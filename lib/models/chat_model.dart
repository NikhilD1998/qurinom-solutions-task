class Chat {
  final String id;
  final List<dynamic> participants;
  final String currentUserId;

  Chat({
    required this.id,
    required this.participants,
    required this.currentUserId,
  });

  factory Chat.fromJson(Map<String, dynamic> json, String currentUserId) {
    return Chat(
      id: json['_id'] ?? '',
      participants: json['participants'] ?? [],
      currentUserId: currentUserId,
    );
  }

  String get chatName {
    // Find the participant whose _id is NOT the current user
    final other = participants.firstWhere(
      (p) => p['_id'] != currentUserId,
      orElse: () => null,
    );
    return other != null ? other['name'] ?? 'Unknown' : 'Unknown';
  }
}
