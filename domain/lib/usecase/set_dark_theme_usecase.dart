import 'package:domain/domain.dart';

class SetDarkThemeUseCase extends FutureUseCase<void, bool> {
  final LaunchRepository _launchRepository;

  SetDarkThemeUseCase({
    required LaunchRepository launchRepository,
  }) : _launchRepository = launchRepository;

  @override
  Future<void> execute(bool params) async {
    return await _launchRepository.setDarkTheme(params);
  }
}
