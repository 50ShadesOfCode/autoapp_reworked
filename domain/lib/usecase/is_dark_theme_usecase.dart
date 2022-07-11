import 'package:domain/domain.dart';

class IsDarkThemeUseCase extends UseCase<bool, NoParams> {
  final LaunchRepository _launchRepository;

  IsDarkThemeUseCase({
    required LaunchRepository launchRepository,
  }) : _launchRepository = launchRepository;

  @override
  bool execute(NoParams params) {
    return _launchRepository.isDarkTheme();
  }
}
