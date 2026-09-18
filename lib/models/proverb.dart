class Proverb {
  final String text;
  final String answer;
  final List<String> options;
  final String category;

  const Proverb({
    required this.text,
    required this.answer,
    required this.options,
    this.category = 'Akyl-paýhas',
  });

  factory Proverb.fromJson(Map<String, dynamic> json) {
    return Proverb(
      text: json['text'] as String,
      answer: json['answer'] as String,
      options: List<String>.from(json['options'] as List),
      category: json['category'] as String? ?? 'Akyl-paýhas',
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
}
