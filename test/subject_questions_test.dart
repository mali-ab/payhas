import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payhas/models/study_question.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final entry in {
    'assets/filo_edebiyat.json': 30,
    'assets/taryh_tn_dili.json': 50,
  }.entries) {
    test('${entry.key} contains valid answerable questions', () async {
      final raw = await rootBundle.loadString(entry.key);
      final questions = (jsonDecode(raw) as List<dynamic>)
          .map((item) => StudyQuestion.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(questions, hasLength(entry.value));
      for (final question in questions) {
        expect(question.question.trim(), isNotEmpty);
        expect(question.options, contains(question.answer));
        expect(question.options.length, greaterThanOrEqualTo(2));
      }
    });
  }
}
