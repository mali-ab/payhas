import 'api_config.dart';
import '../data/proverb_repository.dart';
import '../data/sources/local_proverb_repository.dart';
import '../data/sources/remote_proverb_repository.dart';

/// Composition root for replaceable app services.
class AppDependencies {
  const AppDependencies({required this.proverbRepository});

  final ProverbRepository proverbRepository;

  factory AppDependencies.local() => AppDependencies(
    proverbRepository: ApiConfig.useRemote
        ? RemoteProverbRepository()
        : LocalProverbRepository(),
  );
}
