import 'package:domain/domain.dart';

class GetUsernameUseCase extends UseCase<String, NoParams> {
  final LaunchRepository _launchRepository;

  GetUsernameUseCase({
    required LaunchRepository launchRepository,
  }) : _launchRepository = launchRepository;

  @override
  String execute(NoParams params) {
    return _launchRepository.getUsername();
  }
}
