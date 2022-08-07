import 'dart:io';

import 'package:auto_app/features/car_screen/car_page.dart';
import 'package:auto_app/features/common/card.dart' as card;
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'bloc/card_bloc.dart';

class CarCard extends StatefulWidget {
  final String cardUrl;
  final bool isFavourite;
  const CarCard({
    required this.cardUrl,
    required this.isFavourite,
  });
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final String cardUrl;
  late final bool isFavourite;

  @override
  void initState() {
    super.initState();
    cardUrl = widget.cardUrl;
    isFavourite = widget.isFavourite;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CardBloc, CardState>(
      builder: (BuildContext context, CardState state) {
        if (state.isLoading) {
          return const card.Card(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final Map<String, dynamic> characteristics = state.data;
          final List<String> urls = <String>[];
          for (int i = 0;
              i < (characteristics['images_urls'].length as int);
              i++) {
            urls.add('http://' + characteristics['images_urls'][i].toString());
          }
          return card.Card(
            InkWell(
              onTap: () => <void>{
                Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            CarPage(carUrl: cardUrl)))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 25,
                    child: InkWell(
                      onTap: () => <void>{
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                CarouselPage(imageUrls: urls),
                          ),
                        )
                      },
                      child: Container(
                        child: Image(
                          image: NetworkImage('http://' +
                              characteristics['images_urls'][0].toString()),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(characteristics['name'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(!cardUrl.contains('/new/')
                              ? characteristics['kmage'].toString()
                              : characteristics['complectation'].toString()),
                          margin:
                              const EdgeInsets.only(top: 3, bottom: 3, left: 2),
                        ),
                        Container(
                          child: Text(characteristics['engine'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text(characteristics['price'].toString()),
                            margin: const EdgeInsets.symmetric(vertical: 3)),
                        Container(
                          child: Text(characteristics['color'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(characteristics['drive'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  //TODO: Add proper favourite logic
                  isFavourite
                      ? Expanded(
                          flex: 8,
                          child: IconButton(
                            iconSize: 35,
                            icon: const Icon(
                              CupertinoIcons.clear,
                            ),
                            onPressed: () async {
                              final Directory docsPath =
                                  await getApplicationDocumentsDirectory();
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
                                whereArgs: <String>[cardUrl],
                              );
                              print('del');
                              setState(() {});
                            },
                          ),
                        )
                      : Expanded(
                          flex: 8,
                          child: StarButton(
                            iconSize: 45,
                            valueChanged: (bool value) async {
                              if (value) {
                                final Directory docsPath =
                                    await getApplicationDocumentsDirectory();
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
                                await db.rawInsert(
                                  'INSERT Into Favs (url)'
                                  ' VALUES (?)',
                                  <Object>[cardUrl],
                                );
                              } else {
                                final Directory docsPath =
                                    await getApplicationDocumentsDirectory();
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
                                  whereArgs: <Object>[cardUrl],
                                );
                              }
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
