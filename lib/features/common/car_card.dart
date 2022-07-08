import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_app/features/common/car_page.dart';
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:auto_app/utils/config.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CarCard extends StatefulWidget {
  final String cardUrl;
  const CarCard({required this.cardUrl});
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final String cardUrl;

  @override
  void initState() {
    super.initState();
    cardUrl = widget.cardUrl;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: getCardParameters(cardUrl),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data == null) {
          return const Card(
            child: Center(
              child: Text('Check your Internet connection!!'),
            ),
          );
        }
        final Map<String, dynamic> characteristics =
            snapshot.data as Map<String, dynamic>;
        final List<String> urls = <String>[];
        for (int i = 0;
            i < (characteristics['images_urls'].length as int);
            i++) {
          urls.add('http://' + characteristics['images_urls'][i].toString());
        }
        return Card(
          child: InkWell(
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
                Expanded(
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
      },
    );
  }
}

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
