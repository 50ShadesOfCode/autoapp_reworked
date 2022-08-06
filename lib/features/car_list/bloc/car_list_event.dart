import 'package:flutter/foundation.dart';

@immutable
abstract class CarListEvent {}

class LoadEvent extends CarListEvent {
  final String url;

  LoadEvent({
    required this.url,
  });
}
