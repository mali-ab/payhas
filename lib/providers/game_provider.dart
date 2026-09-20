import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/proverb.dart';
import '../data/proverb_repository.dart';

enum AnswerState { idle, correct, wrong }

enum Difficulty {
  easy, // Ýeňil: 4 multiple-choice answers
  medium, // Orta: Arrange letters
  hard, // Kyn: Type word manually
}

class GameProvider extends ChangeNotifier {
  GameProvider({required ProverbRepository proverbRepository})
      : _proverbRepository = proverbRepository;

  final ProverbRepository _proverbRepository;
  List<Proverb> _proverbs = [];
  int _index = 0;
  int _score = 0;
  int _streak = 0;
  int _highScore = 0;
  int _totalScore = 0;
  int _coins = 0;
  int _streakDays = 0;
  int _longestStreak = 0;
  int _totalCorrectAnswers = 0;
  int _totalWrongAnswers = 0;
  int _completedQuestions = 0;
  String _username = 'Myhman Oýunçy';
  String _avatar = '🧑‍🎓';

  int _level = 5;
  int _xp = 340;
  int _lives = 5;
  static const int maxLives = 5;

  int _correctCount = 0;
  int _wrongCount = 0;
  bool _awaitingContinue = false;

  Difficulty _difficulty = Difficulty.easy;
  String _selectedCategory = 'Hemmesi';

  bool _dailyCompleted = false;
  AnswerState _answerState = AnswerState.idle;
  String? _selectedOption;
  List<String> _shuffledOptions = [];

  // Hints system
  final Set<String> _removedOptions = {};
  String? _revealedPart;

  // For Medium difficulty (Arrange letters)
  List<String> _scrambledLetters = [];
  List<String> _assembledLetters = [];
  List<bool> _letterUsed = [];

  // For Hard difficulty (Manual typing)
  String _typedAnswer = '';

  // Daily Challenge state
  List<Proverb> _dailyProverbs = [];
  int _dailyIndex = 0;
  int _dailyCorrectCount = 0;
  bool _dailyFinished = false;

  bool _loading = true;
  bool _finished = false;
  String _storagePrefix = 'guest_';

  String _key(String key) => '$_storagePrefix$key';

  // Getters
  List<Proverb> get proverbs => _proverbs;
  Proverb? get current =>
      (_proverbs.isEmpty || _index >= _proverbs.length) ? null : _proverbs[_index];
  int get score => _score;
  int get streak => _streak;
  int get highScore => _highScore;
  int get totalScore => _totalScore;
  int get coins => _coins;
  int get streakDays => _streakDays;
  int get longestStreak => _longestStreak;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  int get totalWrongAnswers => _totalWrongAnswers;
  int get completedQuestions => _completedQuestions;
  String get username => _username;
  String get avatar => _avatar;

  int get level => _level;
  int get xp => _xp;
  int get lives => _lives;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  bool get awaitingContinue => _awaitingContinue;
  Difficulty get difficulty => _difficulty;
  String get selectedCategory => _selectedCategory;

  bool get dailyCompleted => _dailyCompleted;
  AnswerState get answerState => _answerState;
  String? get selectedOption => _selectedOption;
  List<String> get shuffledOptions => _shuffledOptions;
  Set<String> get removedOptions => _removedOptions;
  String? get revealedPart => _revealedPart;

  List<String> get scrambledLetters => _scrambledLetters;
  List<String> get assembledLetters => _assembledLetters;
  List<bool> get letterUsed => _letterUsed;
  String get typedAnswer => _typedAnswer;

  List<Proverb> get dailyProverbs => _dailyProverbs;
  int get dailyIndex => _dailyIndex;
  int get dailyCorrectCount => _dailyCorrectCount;
  bool get dailyFinished => _dailyFinished;
  Proverb? get currentDaily =>
      (_dailyProverbs.isEmpty || _dailyIndex >= _dailyProverbs.length)
          ? null
          : _dailyProverbs[_dailyIndex];

  bool get loading => _loading;
  bool get finished => _finished;
  int get total => _proverbs.length;
  int get currentIndex => _index;

  int get xpToNextLevel => _level * 100;
  double get xpProgress => (_xp % xpToNextLevel) / xpToNextLevel;

  String get levelTitle {
    if (_level <= 2) return 'Başlangyç';
    if (_level <= 4) return 'Synagçy';
    if (_level <= 6) return 'Bilgir';
    if (_level <= 8) return 'Paýhasly';
    if (_level <= 10) return 'Alym';
    return 'Danyşment';
  }

  String get difficultyTitle {
    switch (_difficulty) {
      case Difficulty.easy:
        return 'Ýeňil';
      case Difficulty.medium:
        return 'Orta';
      case Difficulty.hard:
        return 'Kyn';
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt(_key('high_score')) ?? 0;
    _totalScore = prefs.getInt(_key('total_score')) ?? 0;
    _coins = prefs.getInt(_key('coins')) ?? 0;
    _streakDays = prefs.getInt(_key('streak_days')) ?? 0;
    _longestStreak = prefs.getInt(_key('longest_streak')) ?? 0;
    _totalCorrectAnswers = prefs.getInt(_key('total_correct_answers')) ?? 0;
    _totalWrongAnswers = prefs.getInt(_key('total_wrong_answers')) ?? 0;
    _completedQuestions = prefs.getInt(_key('completed_questions')) ?? 0;
    _username = prefs.getString(_key('player_username')) ?? _username;
    _avatar = prefs.getString(_key('player_avatar')) ?? _avatar;
    _level = prefs.getInt(_key('player_level')) ?? 1;
    _xp = prefs.getInt(_key('player_xp')) ?? 0;

    final lastDaily = prefs.getString(_key('daily_last_date'));
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    _dailyCompleted = (lastDaily == todayStr);
    notifyListeners();
  }

  /// Selects a separate local data store for the signed-in account.
  Future<void> activateUser({required int id, required String name, required String avatar}) async {
    _storagePrefix = 'user_${id}_';
    _username = name;
    _avatar = avatar;
    await init();
    // Account profile is authoritative; game stats remain local and per-user.
    _username = name;
    _avatar = avatar;
    notifyListeners();
  }

  Future<void> setUsername(String newName) async {
    _username = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key('player_username'), _username);
    notifyListeners();
  }

  Future<void> setAvatar(String newAvatar) async {
    _avatar = newAvatar;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key('player_avatar'), _avatar);
    notifyListeners();
  }

  Future<void> startNewGame({
    String? category,
    Difficulty difficulty = Difficulty.easy,
    int questionCount = 20,
  }) async {
    _loading = true;
    notifyListeners();

    await init();
    _difficulty = difficulty;
    _selectedCategory = category ?? 'Hemmesi';

    _proverbs = await _proverbRepository.getQuestions(
      category: _selectedCategory == 'Hemmesi' ? null : _selectedCategory,
      difficulty: difficulty.name,
      count: questionCount,
    );

    _index = 0;
    _score = 0;
    _streak = 0;
    _lives = maxLives;
    _correctCount = 0;
    _wrongCount = 0;
    _finished = false;
    _awaitingContinue = false;

    _setupCurrentQuestion();
    _loading = false;
    notifyListeners();
  }

  void _setupCurrentQuestion() {
    if (current == null) return;
    _answerState = AnswerState.idle;
    _selectedOption = null;
    _awaitingContinue = false;
    _removedOptions.clear();
    _revealedPart = null;

    // Easy: Shuffled options
    _shuffledOptions = List<String>.from(current!.options)..shuffle(Random());

    // Medium: Scrambled letters
    final targetWord = current!.answer.toLowerCase().trim();
    final letters = targetWord.split('');
    const decoyPool = ['a', 'e', 'y', 'i', 'd', 's', 'r', 'l', 'ä', 'ň', 'ö', 'ü', 'ş'];
    final rnd = Random();
    while (letters.length < targetWord.length + 2) {
      final extra = decoyPool[rnd.nextInt(decoyPool.length)];
      letters.add(extra);
    }
    letters.shuffle(rnd);
    _scrambledLetters = letters;
    _letterUsed = List<bool>.filled(letters.length, false);
    _assembledLetters = [];

    // Hard: empty typed answer
    _typedAnswer = '';
  }

  // --- HINT 1: 💡 Maslahat (Remove one wrong option) ---
  bool useHintRemoveWrong({int cost = 20}) {
    if (_coins < cost || current == null || _awaitingContinue) return false;
    final correctAnswer = current!.answer.toLowerCase().trim();
    final wrongOptions = _shuffledOptions.where((opt) {
      return opt.toLowerCase().trim() != correctAnswer &&
          !_removedOptions.contains(opt);
    }).toList();

    if (wrongOptions.isNotEmpty) {
      final toRemove = wrongOptions[Random().nextInt(wrongOptions.length)];
      _removedOptions.add(toRemove);
      _coins -= cost;
      _saveStats();
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- HINT 2: 🔍 Jogabyň bir bölegini görkez (Reveal part of answer) ---
  bool useHintRevealPart({int cost = 30}) {
    if (_coins < cost || current == null || _awaitingContinue) return false;
    final target = current!.answer;
    final revealCount = target.length > 3 ? 2 : 1;
    _revealedPart = target.substring(0, revealCount);
    _coins -= cost;

    if (_difficulty == Difficulty.hard && _typedAnswer.isEmpty) {
      _typedAnswer = _revealedPart!;
    }
    _saveStats();
    notifyListeners();
    return true;
  }

  // --- HINT 3: ❤️ Durmuş (Restore one life) ---
  bool useHintRestoreLife({int cost = 25}) {
    if (_coins < cost || _lives >= maxLives) return false;
    _lives++;
    _coins -= cost;
    _saveStats();
    notifyListeners();
    return true;
  }

  // Easy mode answer selection
  void selectOption(String option) {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    _selectedOption = option;
    final isCorrect = (option.toLowerCase().trim() == current!.answer.toLowerCase().trim());
    _handleAnswerResult(isCorrect);
  }

  // Medium mode letter toggle
  void toggleScrambledLetter(int index) {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    if (_letterUsed[index]) return;

    _letterUsed[index] = true;
    _assembledLetters.add(_scrambledLetters[index]);
    notifyListeners();

    if (_assembledLetters.length == current!.answer.trim().length) {
      checkMediumAnswer();
    }
  }

  void removeAssembledLetter(int index) {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    if (index >= _assembledLetters.length) return;

    final letter = _assembledLetters.removeAt(index);
    for (int i = 0; i < _scrambledLetters.length; i++) {
      if (_scrambledLetters[i] == letter && _letterUsed[i]) {
        _letterUsed[i] = false;
        break;
      }
    }
    notifyListeners();
  }

  void clearAssembledLetters() {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    _assembledLetters.clear();
    _letterUsed = List<bool>.filled(_scrambledLetters.length, false);
    notifyListeners();
  }

  void checkMediumAnswer() {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    final assembled = _assembledLetters.join('').toLowerCase().trim();
    final target = current!.answer.toLowerCase().trim();
    final isCorrect = (assembled == target);
    _selectedOption = assembled;
    _handleAnswerResult(isCorrect);
  }

  // Hard mode manual typing
  void updateTypedAnswer(String text) {
    _typedAnswer = text;
    notifyListeners();
  }

  void appendTypedChar(String char) {
    _typedAnswer += char;
    notifyListeners();
  }

  void backspaceTyped() {
    if (_typedAnswer.isNotEmpty) {
      _typedAnswer = _typedAnswer.substring(0, _typedAnswer.length - 1);
      notifyListeners();
    }
  }

  void checkTypedAnswer() {
    if (_answerState != AnswerState.idle || _awaitingContinue) return;
    final entered = _typedAnswer.toLowerCase().trim();
    final target = current!.answer.toLowerCase().trim();
    final isCorrect = (entered == target);
    _selectedOption = entered;
    _handleAnswerResult(isCorrect);
  }

  void _handleAnswerResult(bool isCorrect) {
    _awaitingContinue = true;
    _completedQuestions++;

    if (isCorrect) {
      _answerState = AnswerState.correct;
      final points = 10 + (_streak * 2);
      _score += points;
      _totalScore += points;
      _streak++;
      if (_streak > _longestStreak) {
        _longestStreak = _streak;
      }
      _coins += 5;
      _xp += 20;
      _correctCount++;
      _totalCorrectAnswers++;

      if (_streak > 0 && _streak % 3 == 0) {
        _coins += 10;
      }

      _checkLevelUp();
    } else {
      _answerState = AnswerState.wrong;
      _streak = 0;
      _lives = max(0, _lives - 1);
      _wrongCount++;
      _totalWrongAnswers++;
    }
    _saveStats();
    notifyListeners();
  }

  void advanceNext() {
    if (!_awaitingContinue) return;

    if (_lives <= 0) {
      _finished = true;
      _saveStats();
      notifyListeners();
      return;
    }

    if (_index < _proverbs.length - 1) {
      _index++;
      _setupCurrentQuestion();
    } else {
      _finished = true;
      _saveStats();
    }
    notifyListeners();
  }

  bool refillLives({int cost = 50}) {
    if (_coins >= cost) {
      _coins -= cost;
      _lives = maxLives;
      _saveStats();
      notifyListeners();
      return true;
    }
    return false;
  }

  void _checkLevelUp() {
    if (_xp >= xpToNextLevel && _level < 10) {
      _level++;
      _coins += 25;
    }
  }

  // --- DAILY CHALLENGE (5 Questions) ---
  Future<void> startDailyChallenge() async {
    _loading = true;
    notifyListeners();
    await init();

    _dailyProverbs = await _proverbRepository.getDailyQuestions(
      date: DateTime.now(),
      count: 5,
    );
    _dailyIndex = 0;
    _dailyCorrectCount = 0;
    _dailyFinished = false;
    _loading = false;
    notifyListeners();
  }

  void advanceDailyQuestion(bool wasCorrect) {
    _completedQuestions++;
    if (wasCorrect) {
      _dailyCorrectCount++;
      _totalCorrectAnswers++;
    } else {
      _totalWrongAnswers++;
    }

    if (_dailyIndex < _dailyProverbs.length - 1) {
      _dailyIndex++;
    } else {
      _dailyFinished = true;
    }
    _saveStats();
    notifyListeners();
  }

  Future<void> claimDailyChallengeReward() async {
    _coins += 50;
    _xp += 100;
    _totalScore += 50;
    _streakDays++;
    if (_streakDays > _longestStreak) {
      _longestStreak = _streakDays;
    }
    _dailyCompleted = true;

    final prefs = await SharedPreferences.getInstance();
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString(_key('daily_last_date'), todayStr);
    await _saveStats();
    notifyListeners();
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    if (_score > _highScore) {
      _highScore = _score;
      await prefs.setInt(_key('high_score'), _highScore);
    }
    await prefs.setInt(_key('total_score'), _totalScore);
    await prefs.setInt(_key('coins'), _coins);
    await prefs.setInt(_key('player_level'), _level);
    await prefs.setInt(_key('player_xp'), _xp);
    await prefs.setInt(_key('streak_days'), _streakDays);
    await prefs.setInt(_key('longest_streak'), _longestStreak);
    await prefs.setInt(_key('total_correct_answers'), _totalCorrectAnswers);
    await prefs.setInt(_key('total_wrong_answers'), _totalWrongAnswers);
    await prefs.setInt(_key('completed_questions'), _completedQuestions);
    await prefs.setString(_key('player_username'), _username);
    await prefs.setString(_key('player_avatar'), _avatar);
  }

  Future<void> restart() async {
    await startNewGame(
      category: _selectedCategory,
      difficulty: _difficulty,
    );
  }
}
