import '../data/proverb_repository.dart';
import '../data/sources/local_proverb_repository.dart';
import '../data/sources/remote_proverb_repository.dart';

/// Composition root for replaceable app services.
class AppDependencies {
  const AppDependencies({required this.proverbRepository});

  final ProverbRepository proverbRepository;

  factory AppDependencies.local() => AppDependencies(
        proverbRepository: const bool.fromEnvironment('USE_REMOTE_API')
            ? RemoteProverbRepository()
            : LocalProverbRepository(),
      );
}
