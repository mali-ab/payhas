import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../models/proverb.dart';
import '../proverb_repository.dart';

/// Offline source bundled with the app. It is deliberately behind the
/// repository boundary so a FastAPI source can be added later.
class LocalProverbRepository implements ProverbRepository {
  List<Proverb>? _cache;

  Future<List<Proverb>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/proverbs.json');
    final items = jsonDecode(raw) as List<dynamic>;
    _cache = items
        .map((item) => Proverb.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    return _cache!;
  }

  @override
  Future<List<Proverb>> getQuestions({
    String? category,
    String? difficulty,
    required int count,
  }) async {
    final all = await _load();
    var matches = all.where((question) {
      final categoryMatches = category == null ||
          category.isEmpty ||
          category == 'Hemmesi' ||
          question.category == category;
      final difficultyMatches = difficulty == null ||
          difficulty.isEmpty ||
          question.difficulty == difficulty;
      return categoryMatches && difficultyMatches;
    }).toList();

    // A short category should still start instantly. Fill from the local pool
    // while retaining all matching questions first.
    if (matches.length < count) {
      final fallback = all
          .where((question) => !matches.any((item) => item.id == question.id))
          .toList()
        ..shuffle(Random());
      matches.addAll(fallback.take(count - matches.length));
    }
    matches.shuffle(Random());
    return matches.take(count).toList(growable: false);
  }

  @override
  Future<List<Proverb>> getDailyQuestions({
    required DateTime date,
    required int count,
  }) async {
    final all = await _load();
    if (all.isEmpty) return const [];
    final day = DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(2025))
        .inDays;
    final start = day.abs() % all.length;
    return List<Proverb>.generate(
      count,
      (index) => all[(start + index) % all.length],
      growable: false,
    );
  }
}
