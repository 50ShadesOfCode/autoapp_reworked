import 'package:domain/domain.dart';

class SetUsernameUseCase extends UseCase<void, String> {
  final LaunchRepository _launchRepository;

  SetUsernameUseCase({
    required LaunchRepository launchRepository,
  }) : _launchRepository = launchRepository;

  @override
  Future<void> execute(String params) async {
    return await _launchRepository.setUsername(params);
  }
}
