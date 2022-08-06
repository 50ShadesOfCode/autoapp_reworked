import 'package:flutter/foundation.dart';

@immutable
abstract class CardEvent {}

class LoadEvent extends CardEvent {
  final String url;

  LoadEvent({
    required this.url,
  });
}
