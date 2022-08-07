import 'dart:io';

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

export 'favourite_event.dart';
export 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final ApiProvider _apiProvider;

  FavouriteBloc({
    required ApiProvider apiProvider,
  })  : _apiProvider = apiProvider,
        super(FavouriteState(
          isLoading: true,
          data: <String>[],
        )) {
    on<LoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
      LoadEvent event, Emitter<FavouriteState> emit) async {
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
    final List<Map<String, Object?>> res = await db.query('Favs');
    final List<String> list = res.isNotEmpty
        ? res.map((Map<String, Object?> e) => FavModel.fromMap(e).url).toList()
        : <String>[];
    emit(state.copyWith(isLoading: false, data: list));
  }
}
