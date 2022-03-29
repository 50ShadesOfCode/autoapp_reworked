import 'dart:convert';

import 'package:auto_app/components/themeProvider.dart';
import 'package:auto_app/utils/FavModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'carPage.dart';
import 'carouselPage.dart';

//функция, которая возвращает список ссылок на автомобили, хранящиеся в бд
Future<List<String>> buildList() async {
  //получаем путь к папке "Documents"
  var docsPath = await getApplicationDocumentsDirectory();
  //создаем или открываем "autofavs.db"
  var db = await openDatabase(docsPath.path + 'autofavs.db', version: 1,
      onCreate: (Database db, int version) async {
    await db.execute("CREATE TABLE Favs ("
        "url TEXT"
        ")");
  });
  //получаем все избранные
  var res = await db.query("Favs");
  //создаем из них список
  List<FavModel> list =
      res.isNotEmpty ? res.map((c) => FavModel.fromMap(c)).toList() : [];
  List<String> urls = [];
  //а потом список только из ссылок
  for (FavModel ms in list) {
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
        title: Text('Избранные'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                this.setState(() {});
              },
              child: Icon(
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
              margin: EdgeInsets.all(5),
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
                              future: getCardParameters(snap.data?[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Map<String, dynamic>>
                                      snapshot) {
                                final provider =
                                    Provider.of<ThemeProvider>(context);
                                //если все еще ожидаем ответ, возвращаем индикатор загрузки
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: (provider.isDarkMode
                                            ? Colors.black
                                            : Colors.white),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0, 3),
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
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                                //Если сервер не отвечает
                                if (snapshot.data == null) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: (provider.isDarkMode
                                            ? Colors.black
                                            : Colors.white),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(0, 3),
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
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: Text("Сервер не отвечает!"),
                                      ));
                                }
                                //получаем данные о характеристиках
                                Map<String, dynamic> cChars =
                                    snapshot.data as Map<String, dynamic>;
                                List<String> urls = [];
                                for (int i = 0;
                                    i < cChars["images_urls"].length;
                                    i++) {
                                  urls.add("http://" +
                                      cChars["images_urls"][i].toString());
                                }
                                //получаем ссылку на автомобиль
                                String url = snap.data?[index] as String;
                                //такая же стиуация как с карточками, может быть два варианта
                                //1. Подержаная
                                if (!url.contains("/new/")) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: (provider.isDarkMode
                                          ? Colors.black
                                          : Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 3),
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
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CarPage(carUrl: url)))
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 25,
                                              child: InkWell(
                                                onTap: () => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CarouselPage(
                                                              imageUrls: urls),
                                                    ),
                                                  )
                                                },
                                                child: Container(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        "http://" +
                                                            cChars["images_urls"]
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
                                                children: [
                                                  Container(
                                                    child: Text(cChars["name"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars["kmage"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars["engine"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          cChars["price"]
                                                              .toString()),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3)),
                                                  Container(
                                                    child: Text(cChars["color"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars["drive"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: IconButton(
                                                iconSize: 35,
                                                icon:
                                                    Icon(CupertinoIcons.clear),
                                                onPressed: () async {
                                                  var docsPath =
                                                      await getApplicationDocumentsDirectory();
                                                  var db = await openDatabase(
                                                      docsPath.path +
                                                          'autofavs.db',
                                                      version: 1,
                                                      onCreate: (Database db,
                                                          int version) async {
                                                    await db.execute(
                                                        "CREATE TABLE Favs ("
                                                        "url TEXT"
                                                        ")");
                                                  });
                                                  db.delete("Favs",
                                                      where: "url = ?",
                                                      whereArgs: [url]);
                                                  print("del");
                                                  //обновление страницы
                                                  this.setState(() {});
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 3),
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
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CarPage(carUrl: url)))
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 25,
                                              child: InkWell(
                                                onTap: () => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CarouselPage(
                                                              imageUrls: urls),
                                                    ),
                                                  )
                                                },
                                                child: Container(
                                                  child: Image(
                                                    image: NetworkImage(
                                                        "http://" +
                                                            cChars["images_urls"]
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
                                                children: [
                                                  Container(
                                                    child: Text(cChars["name"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        cChars["complectation"]
                                                            .toString()),
                                                    margin: EdgeInsets.only(
                                                        top: 3,
                                                        bottom: 3,
                                                        left: 2),
                                                  ),
                                                  Container(
                                                    child: Text(cChars["engine"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          cChars["price"]
                                                              .toString()),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3)),
                                                  Container(
                                                    child: Text(cChars["color"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                  Container(
                                                    child: Text(cChars["drive"]
                                                        .toString()),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: IconButton(
                                                iconSize: 35,
                                                icon:
                                                    Icon(CupertinoIcons.clear),
                                                onPressed: () async {
                                                  var docsPath =
                                                      await getApplicationDocumentsDirectory();
                                                  var db = await openDatabase(
                                                      docsPath.path +
                                                          'autofavs.db',
                                                      version: 1,
                                                      onCreate: (Database db,
                                                          int version) async {
                                                    await db.execute(
                                                        "CREATE TABLE Favs ("
                                                        "url TEXT"
                                                        ")");
                                                  });
                                                  db.delete("Favs",
                                                      where: "url = ?",
                                                      whereArgs: [url]);
                                                  print("del");
                                                  //обновление страницы
                                                  this.setState(() {});
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
Future<Map<String, dynamic>> getCardParameters(carUrl) async {
  print(carUrl);
  var url = Uri.parse("https://autoparseru.herokuapp.com/getCardByUrl");
  var body = json.encode({"url": carUrl});
  var res = await http.post(url, body: body, headers: headers);
  if (res.statusCode == 200) {
    Map<String, dynamic> jsonRes = json.decode(res.body);
    return jsonRes;
  } else {
    return Map<String, dynamic>();
  }
}

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};
