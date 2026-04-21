class ChizmachilikQuestion {
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;

  const ChizmachilikQuestion({
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
  });

  // copyWith
  ChizmachilikQuestion copyWith({
    String? question,
    String? answer1,
    String? answer2,
    String? answer3,
    String? answer4,
  }) {
    return ChizmachilikQuestion(
      question: question ?? this.question,
      answer1:  answer1  ?? this.answer1,
      answer2:  answer2  ?? this.answer2,
      answer3:  answer3  ?? this.answer3,
      answer4:  answer4  ?? this.answer4,
    );
  }

  // ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChizmachilikQuestion &&
        other.question == question &&
        other.answer1  == answer1  &&
        other.answer2  == answer2  &&
        other.answer3  == answer3  &&
        other.answer4  == answer4;
  }

  // hashCode
  @override
  int get hashCode => Object.hash(
    question,
    answer1,
    answer2,
    answer3,
    answer4,
  );

  // toString
  @override
  String toString() {
    return 'ChizmachilikQuestion('
        'question: $question, '
        'answer1: $answer1, '
        'answer2: $answer2, '
        'answer3: $answer3, '
        'answer4: $answer4)';
  }

  // fromJson
  factory ChizmachilikQuestion.fromJson(Map<String, dynamic> json) {
    return ChizmachilikQuestion(
      question: json['question'] as String,
      answer1:  json['answer1']  as String,
      answer2:  json['answer2']  as String,
      answer3:  json['answer3']  as String,
      answer4:  json['answer4']  as String,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer1':  answer1,
      'answer2':  answer2,
      'answer3':  answer3,
      'answer4':  answer4,
    };
  }
}
