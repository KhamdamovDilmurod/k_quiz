class Topic {
  final int bookId;
  final int topicId;
  final String topic;

  Topic({
    required this.bookId,
    required this.topicId,
    required this.topic,
  });

  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
      'topic_id': topicId,
      'topic': topic,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      bookId: map['book_id'],
      topicId: map['topic_id'],
      topic: map['topic'],
    );
  }
}