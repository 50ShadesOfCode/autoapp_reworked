import 'package:flutter/foundation.dart';

@immutable
abstract class CharacteristicsEvent {}

class LoadEvent extends CharacteristicsEvent {
  final String url;

  LoadEvent({
    required this.url,
  });
}
