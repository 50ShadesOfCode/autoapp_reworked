import 'package:flutter/foundation.dart';

@immutable
abstract class SettingsEvent {}

class InitSettingsEvent extends SettingsEvent {}

class SwitchThemeEvent extends SettingsEvent {}

class SetUsernameEvent extends SettingsEvent {
  final String username;

  SetUsernameEvent({
    required this.username,
  });
}
