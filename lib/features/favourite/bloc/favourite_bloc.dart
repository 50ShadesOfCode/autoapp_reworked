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
          cars: <Car>[],
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
    final List<FavModel> list =
        res.isNotEmpty ? res.map(FavModel.fromMap).toList() : <FavModel>[];
    final List<String> urls = <String>[];
    for (final FavModel ms in list) {
      urls.add(ms.url);
    }
    final List<Car> cars = <Car>[];
    for (int i = 0; i < list.length; i++) {
      final Map<String, dynamic> carData =
          await _apiProvider.getCardByUrl(urls[i]);
      if (carData.isEmpty) continue;
      final List<String> imagesurls = <String>[];
      for (int i = 0; i < (carData['images_urls'].length as int); i++) {
        imagesurls.add(carData['images_urls'][i].toString());
      }
      cars.add(Car(
        isFavourite: false,
        characteristics: carData,
        images: imagesurls,
        url: urls[i],
        used: !urls[i].contains('/new/'),
      ));
    }
    print(urls);
    emit(state.copyWith(isLoading: false, data: urls, cars: cars));
  }
}
