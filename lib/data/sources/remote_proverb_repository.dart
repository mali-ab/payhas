import '../../models/proverb.dart';
import '../proverb_repository.dart';

/// Future REST adapter for FastAPI. Authentication, sync, multiplayer and
/// cloud leaderboards can be introduced here while UI continues to depend on
/// [ProverbRepository]. It is deliberately not used by the offline release.
class RemoteProverbRepository implements ProverbRepository {
  const RemoteProverbRepository();

  @override
  Future<List<Proverb>> getQuestions({
    String? category,
    String? difficulty,
    required int count,
  }) => throw UnimplementedError('Remote questions are not enabled yet.');

  @override
  Future<List<Proverb>> getDailyQuestions({
    required DateTime date,
    required int count,
  }) => throw UnimplementedError('Remote daily challenges are not enabled yet.');
}
