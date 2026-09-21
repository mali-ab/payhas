import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';

import '../models/leaderboard_entry.dart';
import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const _filters = ['Şu gün', 'Bu hepde', 'Şu aý', 'Ähli wagt'];
  static const _periods = ['today', 'week', 'month', 'all'];
  int _filterIndex = 3;
  bool _loading = true;
  String? _error;
  List<LeaderboardEntry> _leaders = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    setState(() { _loading = true; _error = null; });
    final auth = context.read<AuthProvider>();
    final game = context.read<GameProvider>();
    try {
      await auth.syncStats(
        totalScore: game.totalScore,
        level: game.level,
        xp: game.xp,
        coins: game.coins,
        streakDays: game.streakDays,
        longestStreak: game.longestStreak,
        totalCorrectAnswers: game.totalCorrectAnswers,
        totalWrongAnswers: game.totalWrongAnswers,
        completedQuestions: game.completedQuestions,
      );
      final leaders = await auth.getLeaderboard(_periods[_filterIndex]);
      if (mounted) setState(() => _leaders = leaders);
    } catch (_) {
      if (mounted) setState(() => _error = 'Reýting maglumatlaryny ýükläp bolmady.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final auth = context.watch<AuthProvider>();
    final me = auth.user;
    final myEntries = _leaders.where((entry) => entry.id == me?.id).toList();
    final myEntry = myEntries.isEmpty ? null : myEntries.first;
    final top = _leaders.take(3).toList();
    final rest = _leaders.skip(3).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.textPrimary, size: 19)),
                  const Text('REÝTİNG', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  const Spacer(),
                  IconButton(onPressed: _loading ? null : _refresh, icon: const Icon(LucideIcons.refreshCw, color: AppTheme.accentLight)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _filterBar(),
              ),
              const SizedBox(height: 18),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator(color: AppTheme.accent)))
              else if (_error != null)
                Expanded(child: _message(_error!, Icons.cloud_off_rounded, action: _refresh))
              else if (_leaders.isEmpty)
                const Expanded(child: _EmptyLeaderboard())
              else ...[
                if (top.length == 3) _podium(top),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    itemCount: top.length == 3 ? rest.length : _leaders.length,
                    itemBuilder: (context, index) => _row(top.length == 3 ? rest[index] : _leaders[index], me?.id),
                  ),
                ),
              ],
              _myRank(game, myEntry, me?.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterBar() => Container(
    height: 44,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.cardBorder)),
    child: Row(children: List.generate(_filters.length, (index) => Expanded(
      child: InkWell(
        onTap: () { if (_filterIndex != index) { setState(() => _filterIndex = index); _refresh(); } },
        borderRadius: BorderRadius.circular(10),
        child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: _filterIndex == index ? AppTheme.accent : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text(_filters[index], style: TextStyle(color: _filterIndex == index ? Colors.white : AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700))),
      ),
    ))),
  );

  Widget _podium(List<LeaderboardEntry> top) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      _podiumItem(top[1], '🥈', 105, const Color(0xFFB0BEC5)),
      const SizedBox(width: 10),
      _podiumItem(top[0], '🥇', 130, AppTheme.gold),
      const SizedBox(width: 10),
      _podiumItem(top[2], '🥉', 90, const Color(0xFFCD7F32)),
    ]),
  );

  Widget _podiumItem(LeaderboardEntry entry, String medal, double height, Color color) => Expanded(
    child: Column(children: [
      Text(entry.avatar, style: const TextStyle(fontSize: 28)),
      Text(entry.name.split(' ').first, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
      Text('⭐ ${entry.score}', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Container(height: height, alignment: Alignment.center, decoration: BoxDecoration(color: color.withValues(alpha: .16), borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), border: Border.all(color: color)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(medal, style: const TextStyle(fontSize: 27)), Text('${entry.level} dereje', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11))])),
    ]),
  );

  Widget _row(LeaderboardEntry entry, int? currentUserId) => Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: entry.id == currentUserId ? AppTheme.accent.withValues(alpha: .17) : AppTheme.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: entry.id == currentUserId ? AppTheme.accentLight : AppTheme.cardBorder)),
    child: Row(children: [
      SizedBox(width: 35, child: Text('#${entry.rank}', style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w800))),
      Text(entry.avatar, style: const TextStyle(fontSize: 23)), const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.id == currentUserId ? '${entry.name} (Siz)' : entry.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)), Text('${entry.level}-nji dereje', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))])),
      Text('⭐ ${entry.score}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w800)),
    ]),
  );

  Widget _myRank(GameProvider game, LeaderboardEntry? entry, String? name) => Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    decoration: const BoxDecoration(color: AppTheme.bg2, border: Border(top: BorderSide(color: AppTheme.cardBorder))),
    child: Row(children: [
      Text(entry == null ? '—' : '#${entry.rank}', style: const TextStyle(color: AppTheme.accentLight, fontSize: 17, fontWeight: FontWeight.w900)), const SizedBox(width: 12),
      Text(game.avatar, style: const TextStyle(fontSize: 23)), const SizedBox(width: 10),
      Expanded(child: Text('${name ?? game.username} (Siz)', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800))),
      Text('⭐ ${entry?.score ?? 0}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900)),
    ]),
  );

  Widget _message(String text, IconData icon, {VoidCallback? action}) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: AppTheme.textSecondary, size: 48), const SizedBox(height: 12), Text(text, style: const TextStyle(color: AppTheme.textSecondary)), if (action != null) TextButton(onPressed: action, child: const Text('Täzeden synanş'))]));
}

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard();
  @override
  Widget build(BuildContext context) => const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.emoji_events_outlined, color: AppTheme.gold, size: 52), SizedBox(height: 12), Text('Soňky netije entek ýok.', style: TextStyle(color: AppTheme.textSecondary)), SizedBox(height: 4), Text('Ilkinji bolup bal gazanyň!', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700))]));
}
