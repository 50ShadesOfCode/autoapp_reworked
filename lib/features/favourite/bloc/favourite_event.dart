import 'package:flutter/foundation.dart';

@immutable
abstract class FavouriteEvent {}

class LoadEvent extends FavouriteEvent {
  final String url;

  LoadEvent({
    required this.url,
  });
}
