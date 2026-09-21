import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'core/app_dependencies.dart';
import 'providers/game_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const PayhasApp());
}

class PayhasApp extends StatelessWidget {
  const PayhasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.local();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider(proverbRepository: dependencies.proverbRepository)),
        ChangeNotifierProvider(create: (_) => AuthProvider()..restoreSession()),
      ],
      child: MaterialApp(
        title: 'Paýhas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const _SessionGate(),
      ),
    );
  }
}

class _SessionGate extends StatefulWidget {
  const _SessionGate();

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  int? _activatedUserId;
  bool _playingAsGuest = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.initializing) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final user = auth.user;
    if (user != null && _activatedUserId != user.id) {
      _activatedUserId = user.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<GameProvider>().activateUser(
                id: user.id,
                name: user.name,
                avatar: user.avatar,
                initialStats: user.stats,
              );
        }
      });
    }
    if (user == null && _activatedUserId != null) {
      _activatedUserId = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<GameProvider>().activateGuest();
      });
    }

    if (auth.isAuthenticated || _playingAsGuest) return const HomeScreen();

    return AuthScreen(
      onContinueAsGuest: () async {
        await context.read<GameProvider>().activateGuest();
        if (mounted) setState(() => _playingAsGuest = true);
      },
    );
  }
}
