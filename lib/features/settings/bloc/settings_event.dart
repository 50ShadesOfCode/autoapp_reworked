import 'package:flutter/foundation.dart';

@immutable
abstract class SettingsEvent {}

class InitEvent extends SettingsEvent {}

class SwitchThemeEvent extends SettingsEvent {}

class SetUsernameEvent extends SettingsEvent {}
