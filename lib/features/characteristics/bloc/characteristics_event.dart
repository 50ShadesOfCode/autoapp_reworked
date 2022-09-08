import 'package:flutter/foundation.dart';

@immutable
abstract class CharacteristicsEvent {}

class LoadCharsEvent extends CharacteristicsEvent {
  final String url;

  LoadCharsEvent({
    required this.url,
  });
}
