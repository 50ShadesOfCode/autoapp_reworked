import 'package:flutter/foundation.dart';

@immutable
abstract class CarListEvent {}

class LoadListEvent extends CarListEvent {
  final String url;

  LoadListEvent({
    required this.url,
  });
}
