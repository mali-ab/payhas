import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/app_user.dart';
import '../models/leaderboard_entry.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<({String token, AppUser user})> signUp({
    required String name,
    required String email,
    required String password,
  }) => _authenticate(ApiConfig.signUpPath, {
        'name': name,
        'email': email,
        'password': password,
      });

  Future<({String token, AppUser user})> login({
    required String email,
    required String password,
  }) => _authenticate(ApiConfig.loginPath, {
        'email': email,
        'password': password,
      });

  Future<({String token, AppUser user})> _authenticate(
    String path,
    Map<String, String> body,
  ) async {
    try {
      final response = await _client
          .post(_uri(path), headers: _jsonHeaders, body: jsonEncode(body))
          .timeout(const Duration(seconds: 12));
      final data = _read(response);
      return (token: data['access_token'] as String, user: AppUser.fromJson(data['user'] as Map<String, dynamic>));
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Soňky wagtda serwere birikmek mümkin bolmady.');
    }
  }

  Future<AppUser> getProfile(String token) async {
    try {
      final response = await _client.get(_uri(ApiConfig.profilePath), headers: _authHeaders(token)).timeout(const Duration(seconds: 12));
      return AppUser.fromJson(_read(response));
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Soňky wagtda serwere birikmek mümkin bolmady.');
    }
  }

  Future<AppUser> updateProfile(String token, {String? name, String? avatar}) async {
    try {
      final response = await _client.patch(
        _uri(ApiConfig.profilePath),
        headers: _authHeaders(token),
        body: jsonEncode({'name': name, 'avatar': avatar}),
      ).timeout(const Duration(seconds: 12));
      return AppUser.fromJson(_read(response));
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Soňky wagtda serwere birikmek mümkin bolmady.');
    }
  }

  Future<void> submitStats(String token, {
    required int totalScore,
    required int level,
    required int xp,
    required int coins,
    required int streakDays,
    required int longestStreak,
    required int totalCorrectAnswers,
    required int totalWrongAnswers,
    required int completedQuestions,
  }) async {
    try {
      final response = await _client.put(
        _uri('${ApiConfig.leaderboardPath}/me'),
        headers: _authHeaders(token),
        body: jsonEncode({
          'total_score': totalScore,
          'level': level,
          'xp': xp,
          'coins': coins,
          'streak_days': streakDays,
          'longest_streak': longestStreak,
          'total_correct_answers': totalCorrectAnswers,
          'total_wrong_answers': totalWrongAnswers,
          'completed_questions': completedQuestions,
        }),
      ).timeout(const Duration(seconds: 12));
      _read(response);
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Soňky wagtda serwere birikmek mümkin bolmady.');
    }
  }

  Future<List<LeaderboardEntry>> leaderboard(String period) async {
    try {
      final response = await _client.get(_uri(ApiConfig.leaderboardPath).replace(queryParameters: {'period': period})).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) _read(response);
      final items = jsonDecode(response.body) as List<dynamic>;
      return items.map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>)).toList(growable: false);
    } catch (error) {
      if (error is ApiException) rethrow;
      throw const ApiException('Soňky wagtda serwere birikmek mümkin bolmady.');
    }
  }

  static const _jsonHeaders = {'Content-Type': 'application/json'};
  Map<String, String> _authHeaders(String token) => {..._jsonHeaders, 'Authorization': 'Bearer $token'};

  Map<String, dynamic> _read(http.Response response) {
    final raw = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException((raw['detail'] as String?) ?? 'Sorag ýerine ýetirilmedi.');
    }
    return raw;
  }
}
