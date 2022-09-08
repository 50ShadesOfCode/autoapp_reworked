import 'dart:io';

import 'package:data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'card_event.dart';
import 'card_state.dart';

export 'card_event.dart';
export 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final ApiProvider _apiProvider;

  CardBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(CardState(
          url: '',
          isLoading: true,
          data: <String, dynamic>{},
          isFavourite: false,
        )) {
    on<LoadCardEvent>(_onLoadEvent);
    on<AddToFavouriteEvent>(_onAddToFavEvent);
    on<RemoveFromFavouriteEvent>(_onRemoveFromFavEvent);
  }

  Future<void> _onLoadEvent(
      LoadCardEvent event, Emitter<CardState> emit) async {
    final Map<String, dynamic> data =
        await _apiProvider.getCardByUrl(event.url);
    /*final Directory docsPath = await getApplicationDocumentsDirectory();
    print(docsPath);
    final Database db = await openDatabase(
      docsPath.path + 'autofavs.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Favs ('
            'url TEXT'
            ')');
      },
    );
    final List<Map<String, Object?>> result = await db.query(
      'Favs',
      where: 'url = ?',
      whereArgs: <String>[event.url],
    );*/
    //print('db ok');
    emit(state.copyWith(
      url: event.url,
      isLoading: false,
      data: data,
      isFavourite: false,
    ));
  }

  Future<void> _onAddToFavEvent(
      AddToFavouriteEvent event, Emitter<CardState> emit) async {
    final Directory docsPath = await getApplicationDocumentsDirectory();
    final Database db = await openDatabase(
      docsPath.path + 'autofavs.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Favs ('
            'url TEXT'
            ')');
      },
    );
    db.delete(
      'Favs',
      where: 'url = ?',
      whereArgs: <String>[state.url],
    );
    emit(state.copyWith(
      isLoading: state.isLoading,
      data: state.data,
      isFavourite: true,
    ));
  }

  Future<void> _onRemoveFromFavEvent(
      RemoveFromFavouriteEvent event, Emitter<CardState> emit) async {
    final Directory docsPath = await getApplicationDocumentsDirectory();
    final Database db = await openDatabase(
      docsPath.path + 'autofavs.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Favs ('
          'url TEXT'
          ')',
        );
      },
    );
    db.delete(
      'Favs',
      where: 'url = ?',
      whereArgs: <Object>[state.url],
    );
    emit(state.copyWith(
      isLoading: state.isLoading,
      data: state.data,
      isFavourite: false,
    ));
  }
}
