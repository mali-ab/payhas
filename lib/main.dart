import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'core/app_dependencies.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PayhasApp());
}

class PayhasApp extends StatelessWidget {
  const PayhasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.local();
    return ChangeNotifierProvider(
      create: (_) => GameProvider(
        proverbRepository: dependencies.proverbRepository,
      ),
      child: MaterialApp(
        title: 'Paýhas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
