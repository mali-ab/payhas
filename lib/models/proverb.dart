class Proverb {
  final int id;
  final String text;
  final String answer;
  final List<String> options;
  final String category;
  final String difficulty;
  final String explanation;

  const Proverb({
    required this.id,
    required this.text,
    required this.answer,
    required this.options,
    this.category = 'Akyl-paýhas',
    this.difficulty = 'easy',
    this.explanation = '',
  });

  factory Proverb.fromJson(Map<String, dynamic> json) {
    return Proverb(
      id: json['id'] as int? ?? 0,
      text: (json['proverb'] ?? json['text']) as String,
      answer: json['answer'] as String,
      options: List<String>.from(json['options'] as List),
      category: json['category'] as String? ?? 'Akyl-paýhas',
      difficulty: json['difficulty'] as String? ?? 'easy',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  /// Returns the proverb with the missing word filled in
  String get completedText {
    if (text.contains('______')) {
      return text.replaceAll('______', answer);
    }
    if (text.contains('___')) {
      return text.replaceAll('___', answer);
    }
    return '$text $answer';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'proverb': text,
        'answer': answer,
        'options': options,
        'category': category,
        'difficulty': difficulty,
        'explanation': explanation,
      };
}
