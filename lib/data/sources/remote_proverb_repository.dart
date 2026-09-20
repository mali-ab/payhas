import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../../models/proverb.dart';
import '../proverb_repository.dart';

/// REST adapter for FastAPI; selected with `--dart-define=USE_REMOTE_API=true`.
class RemoteProverbRepository implements ProverbRepository {
  RemoteProverbRepository({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  @override
  Future<List<Proverb>> getQuestions({
    String? category,
    String? difficulty,
    required int count,
  }) => _get(ApiConfig.questionsPath, {
        'category': category,
        'difficulty': difficulty,
        'count': '$count',
      });

  @override
  Future<List<Proverb>> getDailyQuestions({
    required DateTime date,
    required int count,
  }) => _get(ApiConfig.dailyChallengePath, {'count': '$count'});

  Future<List<Proverb>> _get(String path, Map<String, String?> parameters) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: {
      for (final entry in parameters.entries)
        if (entry.value != null && entry.value!.isNotEmpty) entry.key: entry.value!,
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) throw Exception('API soragy şowsuz boldy.');
    final items = jsonDecode(response.body) as List<dynamic>;
    return items.map((item) => Proverb.fromJson(item as Map<String, dynamic>)).toList(growable: false);
  }
}
