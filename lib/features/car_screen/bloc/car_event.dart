import 'package:flutter/foundation.dart';

@immutable
abstract class CarEvent {}

class LoadEvent extends CarEvent {
  final String url;

  LoadEvent({
    required this.url,
  });
}
