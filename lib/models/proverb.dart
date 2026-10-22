class Proverb {
  final int id;
  final String text;
  final String answer;
  final List<String> options;
  final String category;
  final String difficulty;
  final String explanation;
  final String missingWord;

  const Proverb({
    required this.id,
    required this.text,
    required this.answer,
    required this.options,
    this.category = 'Akyl-paýhas',
    this.difficulty = 'easy',
    this.explanation = '',
    this.missingWord = '',
  });

  factory Proverb.fromJson(Map<String, dynamic> json) {
    return Proverb(
      id: json['id'] as int? ?? 0,
      text: (json['proverb'] ?? json['text'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
      options: (json['options'] as List<dynamic>? ?? const [])
          .map((option) => option.toString())
          .toList(growable: false),
      category: json['category'] as String? ?? 'Akyl-paýhas',
      difficulty: json['difficulty'] as String? ?? 'easy',
      explanation: json['explanation'] as String? ?? '',
      missingWord: json['missingWord'] as String? ?? '',
    );
  }

  /// Text shown while the player is answering.
  ///
  /// Newer data stores the complete proverb plus the part that should be
  /// hidden. Meaning/multiple-choice questions omit [missingWord] and are
  /// shown unchanged.
  String get questionText {
    if (text.contains('___')) return text;
    if (missingWord.isEmpty) return text;
    final index = text.lastIndexOf(missingWord);
    if (index < 0) return text;
    return text.replaceRange(index, index + missingWord.length, '______');
  }

  bool get hasMissingWord => questionText != text || text.contains('___');

  /// Returns the proverb with the missing word filled in
  String get completedText {
    if (text.contains('______')) {
      return text.replaceAll('______', answer);
    }
    if (text.contains('___')) {
      return text.replaceAll('___', answer);
    }
    // The current data already keeps the complete proverb in `text`.
    return text;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'proverb': text,
    'answer': answer,
    'options': options,
    'category': category,
    'difficulty': difficulty,
    if (explanation.isNotEmpty) 'explanation': explanation,
    if (missingWord.isNotEmpty) 'missingWord': missingWord,
  };
}
