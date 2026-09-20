import '../models/proverb.dart';

/// Boundary used by gameplay. A REST implementation can be substituted later
/// without changing providers or screens.
abstract interface class ProverbRepository {
  Future<List<Proverb>> getQuestions({
    String? category,
    String? difficulty,
    required int count,
  });

  Future<List<Proverb>> getDailyQuestions({
    required DateTime date,
    required int count,
  });
}
