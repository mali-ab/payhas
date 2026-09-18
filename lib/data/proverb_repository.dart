import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/proverb.dart';

class ProverbRepository {
  static List<Proverb>? _cached;

  static Future<List<Proverb>> load() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString('assets/proverbs.json');
    final list = json.decode(raw) as List;
    _cached =
        list.map((e) => Proverb.fromJson(e as Map<String, dynamic>)).toList();
    return _cached!;
  }

  static Future<List<Proverb>> getByCategory(String? category, {int count = 20}) async {
    final all = await load();
    List<Proverb> filtered;
    if (category == null || category.isEmpty || category == 'Hemmesi') {
      filtered = List<Proverb>.from(all);
    } else {
      filtered = all.where((p) => p.category == category).toList();
      // If category has fewer than count items, fill with others to ensure a fun game session
      if (filtered.length < count) {
        final remaining = all.where((p) => p.category != category).toList()
          ..shuffle(Random());
        filtered.addAll(remaining.take(count - filtered.length));
      }
    }
    filtered.shuffle(Random());
    return filtered.take(count).toList();
  }

  static Future<List<Proverb>> shuffled({int count = 20}) async {
    return getByCategory(null, count: count);
  }
}
