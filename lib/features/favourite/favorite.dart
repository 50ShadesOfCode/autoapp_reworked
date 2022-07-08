import 'dart:convert';
import 'dart:io';

import 'package:auto_app/features/common/card.dart' as card;
import 'package:auto_app/features/favourite/favourite_card.dart';
import 'package:auto_app/utils/config.dart';
import 'package:domain/entities/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//TODO: favs in search

Future<List<String>> buildList() async {
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
  return urls;
}

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: const Icon(
                CupertinoIcons.arrow_counterclockwise,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: buildList(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<String>> snap,
        ) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snap.data!.isEmpty &&
              snap.connectionState == ConnectionState.done) {
            return const Center(
              child: Text('Пока еще ничего нет!'),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: snap.data?.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getCardParameters(snap.data![index]),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const card.Card(
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              //Если сервер не отвечает
                              if (snapshot.data == null) {
                                return const card.Card(
                                  Center(
                                    child:
                                        Text('Check your internet connection!'),
                                  ),
                                );
                              }
                              //получаем данные о характеристиках
                              final Map<String, dynamic> cChars =
                                  snapshot.data as Map<String, dynamic>;
                              final List<String> urls = <String>[];
                              for (int i = 0;
                                  i < (cChars['images_urls'].length as int);
                                  i++) {
                                urls.add('http://' +
                                    cChars['images_urls'][i].toString());
                              }
                              //получаем ссылку на автомобиль
                              final String url = snap.data?[index] as String;
                              return FavouriteCard(cardUrl: url);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

//получаем параметры карточки
Future<Map<String, dynamic>> getCardParameters(String carUrl) async {
  print(carUrl);
  final Uri url =
      Uri.parse('https://fpmiautoparser.herokuapp.com/getCardByUrl');
  final String body = json.encode(<String, dynamic>{
    'url': carUrl,
  });
  final http.Response res = await http.post(
    url,
    body: body,
    headers: headers,
  );
  if (res.statusCode == 200) {
    final Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    return jsonRes;
  } else {
    return <String, dynamic>{};
  }
}
