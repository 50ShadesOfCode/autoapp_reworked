import 'dart:convert';
import 'dart:io';

import 'package:core_ui/src/theme_provider.dart';
import 'package:auto_app/features/common/car_page.dart';
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:auto_app/utils/config.dart';
import 'package:domain/entities/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

//функция, которая возвращает список ссылок на автомобили, хранящиеся в бд
Future<List<String>> buildList() async {
  //получаем путь к папке "Documents"
  final Directory docsPath = await getApplicationDocumentsDirectory();
  //создаем или открываем "autofavs.db"
  final Database db = await openDatabase(docsPath.path + 'autofavs.db',
      version: 1, onCreate: (Database db, int version) async {
    await db.execute('CREATE TABLE Favs ('
        'url TEXT'
        ')');
  });
  //получаем все избранные
  final List<Map<String, Object?>> res = await db.query('Favs');
  //создаем из них список
  final List<FavModel> list =
      res.isNotEmpty ? res.map(FavModel.fromMap).toList() : <FavModel>[];
  final List<String> urls = <String>[];
  //а потом список только из ссылок
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
            child: GestureDetector(
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
      //также используем FutureBuilder потому что запросы в БД
      body: FutureBuilder<List<String>>(
          future: buildList(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snap) {
            return Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    //список т.к. избранных много
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: snap.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          //опять FutureBuilder потому что запросы на сервер для получения информации на карточках
                          //в целом работает так же как и CarCard, но перенесено сюда
                          //потому что необходимо обновлять страницу при обновлении или добавлении избранного
                          return FutureBuilder<Map<String, dynamic>>(
                              future: getCardParameters(snap.data![index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Map<String, dynamic>>
                                      snapshot) {
                                final ThemeProvider provider =
                                    Provider.of<ThemeProvider>(context);
                                //если все еще ожидаем ответ, возвращаем индикатор загрузки
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: provider.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 3,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                                //Если сервер не отвечает
                                if (snapshot.data == null) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: provider.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 3,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: const Center(
                                        child: Text('Сервер не отвечает!'),
                                      ));
                                }
                                //получаем данные о характеристиках
                                final Map<String, dynamic> cChars =
                                    snapshot.data as Map<String, dynamic>;
                                final List<String> urls = <String>[];
                                for (int i = 0;
                                    i <
                                        (cChars['images_urls'] as List<String>)
                                            .length;
                                    i++) {
                                  urls.add('http://' +
                                      cChars['images_urls'][i].toString());
                                }
                                //получаем ссылку на автомобиль
                                final String url = snap.data?[index] as String;
                                //такая же стиуация как с карточками, может быть два варианта
                                //1. Подержаная
                                if (!url.contains('/new/')) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: provider.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 3,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () => <void>{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        CarPage(carUrl: url)))
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 25,
                                              child: InkWell(
                                                onTap: () => <void>{
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          CarouselPage(
                                                              imageUrls: urls),
                                                    ),
                                                  )
                                                },
                                                child: Container(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        'http://' +
                                                            cChars['images_urls']
                                                                    [0]
                                                                .toString()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 30,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(cChars['name']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars['kmage']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars['engine']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      child: Text(
                                                          cChars['price']
                                                              .toString()),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3)),
                                                  Container(
                                                    child: Text(cChars['color']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars['drive']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: IconButton(
                                                iconSize: 35,
                                                icon: const Icon(
                                                    CupertinoIcons.clear),
                                                onPressed: () async {
                                                  final Directory docsPath =
                                                      await getApplicationDocumentsDirectory();
                                                  final Database db =
                                                      await openDatabase(
                                                          docsPath.path +
                                                              'autofavs.db',
                                                          version: 1,
                                                          onCreate: (Database
                                                                  db,
                                                              int version) async {
                                                    await db.execute(
                                                        'CREATE TABLE Favs ('
                                                        'url TEXT'
                                                        ')');
                                                  });
                                                  db.delete('Favs',
                                                      where: 'url = ?',
                                                      whereArgs: <String>[url]);
                                                  print('del');
                                                  //обновление страницы
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                } else {
                                  //2. Новая
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 3,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () => <void>{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        CarPage(carUrl: url)))
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 25,
                                              child: InkWell(
                                                onTap: () => <void>{
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          CarouselPage(
                                                              imageUrls: urls),
                                                    ),
                                                  )
                                                },
                                                child: Container(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        'http://' +
                                                            cChars['images_urls']
                                                                    [0]
                                                                .toString()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 30,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(cChars['name']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        cChars['complectation']
                                                            .toString()),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 3,
                                                            left: 2),
                                                  ),
                                                  Container(
                                                    child: Text(cChars['engine']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      child: Text(
                                                          cChars['price']
                                                              .toString()),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3)),
                                                  Container(
                                                    child: Text(cChars['color']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars['drive']
                                                        .toString()),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: IconButton(
                                                iconSize: 35,
                                                icon: const Icon(
                                                    CupertinoIcons.clear),
                                                onPressed: () async {
                                                  final Directory docsPath =
                                                      await getApplicationDocumentsDirectory();
                                                  final Database db =
                                                      await openDatabase(
                                                          docsPath.path +
                                                              'autofavs.db',
                                                          version: 1,
                                                          onCreate: (Database
                                                                  db,
                                                              int version) async {
                                                    await db.execute(
                                                        'CREATE TABLE Favs ('
                                                        'url TEXT'
                                                        ')');
                                                  });
                                                  db.delete('Favs',
                                                      where: 'url = ?',
                                                      whereArgs: <String>[url]);
                                                  print('del');
                                                  //обновление страницы
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                }
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

//получаем параметры карточки
Future<Map<String, dynamic>> getCardParameters(String carUrl) async {
  print(carUrl);
  final Uri url =
      Uri.parse('https://fpmiautoparser.herokuapp.com/getCardByUrl');
  final String body = json.encode(<String, dynamic>{'url': carUrl});
  final http.Response res = await http.post(url, body: body, headers: headers);
  if (res.statusCode == 200) {
    final Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    return jsonRes;
  } else {
    return <String, dynamic>{};
  }
}
