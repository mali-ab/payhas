import '../data/proverb_repository.dart';
import '../data/sources/local_proverb_repository.dart';

/// Composition root for replaceable app services.
class AppDependencies {
  const AppDependencies({required this.proverbRepository});

  final ProverbRepository proverbRepository;

  factory AppDependencies.local() =>
      AppDependencies(proverbRepository: LocalProverbRepository());
}
