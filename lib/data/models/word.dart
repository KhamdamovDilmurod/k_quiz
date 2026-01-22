class Word {
  final int bookId;
  final int topicId;
  final int id;
  final String koreanWord;
  final String uzbekWord;
  final String? desc;

  Word({
    required this.bookId,
    required this.topicId,
    required this.id,
    required this.koreanWord,
    required this.uzbekWord,
    this.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
      'topic_id': topicId,
      'id': id,
      'korean_word': koreanWord,
      'uzbek_word': uzbekWord,
      'desc': desc,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      bookId: map['book_id'],
      topicId: map['topic_id'],
      id: map['id'],
      koreanWord: map['korean_word'],
      uzbekWord: map['uzbek_word'],
      desc: map['desc'],
    );
  }
}