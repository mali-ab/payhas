import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_client.dart';
import '../models/app_user.dart';
import '../models/leaderboard_entry.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiClient? api}) : _api = api ?? ApiClient();
  final ApiClient _api;
  AppUser? _user;
  String? _token;
  bool _initializing = true;
  bool _busy = false;
  String? _error;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null && _token != null;
  bool get initializing => _initializing;
  bool get busy => _busy;
  String? get error => _error;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      try {
        _user = await _api.getProfile(token);
        _token = token;
      } catch (_) {
        await prefs.remove('auth_token');
      }
    }
    _initializing = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) => _run(() => _api.login(email: email, password: password));
  Future<bool> signUp(String name, String email, String password) => _run(() => _api.signUp(name: name, email: email, password: password));

  Future<bool> _run(Future<({String token, AppUser user})> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      final result = await action();
      _token = result.token;
      _user = result.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token);
      return true;
    } on ApiException catch (error) {
      _error = error.message;
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({String? name, String? avatar}) async {
    if (_token == null) return false;
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _api.updateProfile(_token!, name: name, avatar: avatar);
      return true;
    } on ApiException catch (error) {
      _error = error.message;
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    (await SharedPreferences.getInstance()).remove('auth_token');
    notifyListeners();
  }

  Future<void> syncStats({
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
    if (_token == null) return;
    await _api.submitStats(
      _token!,
      totalScore: totalScore,
      level: level,
      xp: xp,
      coins: coins,
      streakDays: streakDays,
      longestStreak: longestStreak,
      totalCorrectAnswers: totalCorrectAnswers,
      totalWrongAnswers: totalWrongAnswers,
      completedQuestions: completedQuestions,
    );
  }

  Future<List<LeaderboardEntry>> getLeaderboard(String period) => _api.leaderboard(period);
}
