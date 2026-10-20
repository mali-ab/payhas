class StudyQuestion {
  const StudyQuestion({
    required this.id,
    required this.question,
    required this.answer,
    required this.options,
    required this.category,
  });

  final int id;
  final String question;
  final String answer;
  final List<String> options;
  final String category;

  factory StudyQuestion.fromJson(Map<String, dynamic> json) => StudyQuestion(
    id: json['id'] as int? ?? 0,
    question: json['question'] as String? ?? '',
    answer: json['answer'] as String? ?? '',
    options: List<String>.from(json['options'] as List? ?? const []),
    category: json['category'] as String? ?? '',
  );
}
