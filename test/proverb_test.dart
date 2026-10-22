import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payhas/models/proverb.dart';
import 'package:payhas/data/sources/local_proverb_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('proverb asset contains valid answerable questions', () async {
    final raw = await rootBundle.loadString('assets/proverbs.json');
    final proverbs = (jsonDecode(raw) as List<dynamic>)
        .map((item) => Proverb.fromJson(item as Map<String, dynamic>))
        .toList();

    expect(proverbs, isNotEmpty);
    expect(proverbs.map((item) => item.id).toSet(), hasLength(proverbs.length));
    for (final proverb in proverbs) {
      expect(proverb.text.trim(), isNotEmpty, reason: 'id ${proverb.id}');
      expect(proverb.answer.trim(), isNotEmpty, reason: 'id ${proverb.id}');
      expect(
        proverb.options,
        contains(proverb.answer),
        reason: 'id ${proverb.id}',
      );
      expect(proverb.options.length, greaterThanOrEqualTo(2));
      if (proverb.missingWord.isNotEmpty) {
        expect(
          proverb.text,
          contains(proverb.missingWord),
          reason: 'id ${proverb.id}',
        );
        expect(proverb.questionText, contains('______'));
        expect(proverb.completedText, proverb.text);
      }
      final wordCount = proverb.missingWord.trim().isEmpty
          ? 0
          : proverb.missingWord.trim().split(RegExp(r'\s+')).length;
      expect(
        proverb.difficulty,
        wordCount == 0 ? 'easy' : (wordCount == 1 ? 'medium' : 'hard'),
        reason: 'id ${proverb.id}',
      );
    }
  });

  test('meaning questions stay unchanged when optional fields are absent', () {
    final proverb = Proverb.fromJson({
      'id': 1,
      'proverb': 'Sorag?',
      'answer': 'Jogap',
      'options': ['Jogap', 'Başga'],
    });

    expect(proverb.questionText, 'Sorag?');
    expect(proverb.explanation, isEmpty);
    expect(proverb.missingWord, isEmpty);
  });

  test('fill-in filter excludes easy-only test questions', () async {
    final repository = LocalProverbRepository();
    final questions = await repository.getQuestions(
      fillInOnly: true,
      count: 100,
    );

    expect(questions, isNotEmpty);
    expect(questions.every((question) => question.hasMissingWord), isTrue);
    expect(questions.length, 26);
  });
}
