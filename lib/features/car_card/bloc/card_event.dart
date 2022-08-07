import 'package:flutter/foundation.dart';

@immutable
abstract class CardEvent {}

class LoadCardEvent extends CardEvent {
  final String url;

  LoadCardEvent({
    required this.url,
  });
}

class AddToFavouriteEvent extends CardEvent {}

class RemoveFromFavouriteEvent extends CardEvent {}
