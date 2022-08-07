import 'package:flutter/foundation.dart';

@immutable
abstract class NotificationsEvent {}

class SaveEvent extends NotificationsEvent {
  final String url;

  SaveEvent({
    required this.url,
  });
}
