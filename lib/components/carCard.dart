import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_app/components/carPage.dart';
import 'package:auto_app/components/themeProvider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'carouselPage.dart';

class CarCard extends StatefulWidget {
  final String cardUrl;
  CarCard({required String cardUrl}) : this.cardUrl = cardUrl;
  @override
  _CarCardState createState() => _CarCardState(cardUrl);
}

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};

class _CarCardState extends State<CarCard> with AutomaticKeepAliveClientMixin {
  @override
  //нужно для того, чтобы карточки не сбрасывались при обновлении страницы
  bool get wantKeepAlive => true;

  _CarCardState(this.cardUrl);
  final String cardUrl;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getCardParameters(this.cardUrl),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          final ThemeProvider provider = Provider.of<ThemeProvider>(context);
          //карточка для показа, пока выполняется запрос на сервер
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
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
                height: MediaQuery.of(context).size.height * 0.15,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
          //карточка, которая показывается в случае того, если данные с сервера не получены
          if (snapshot.data == null) {
            return Container(
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
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
                height: MediaQuery.of(context).size.height * 0.15,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: Text('Check your Internet connection!!'),
                ));
          }
          //если данные получены, то есть два случая которые надо рассматривать отдельно. Если ссылка на новый автомобиль или подержаный.
          Map<String, dynamic> cChars = snapshot.data as Map<String, dynamic>;
          List<String> urls = [];
          for (int i = 0;
              i < (cChars['images_urls'] as List<String>).length;
              i++) {
            urls.add('http://' + (cChars['images_urls'] as List<String>)[i]);
          }
          //если на подержаный, то возвращаем карточку для подержаного
          if (!this.cardUrl.contains('/new/')) {
            return Container(
              //оформление карточки
              decoration: BoxDecoration(
                color: provider.isDarkMode ? Colors.black : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
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
              height: MediaQuery.of(context).size.height * 0.15,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                //при нажатии на карточку будет открываться страница автомобиля с заданной ссылкой
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CarPage(carUrl: this.cardUrl)))
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    flex: 25,
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CarouselPage(imageUrls: urls),
                          ),
                        )
                      },
                      child: Container(
                        child: Image(
                          image: NetworkImage(
                              'http://' + cChars['images_urls'][0].toString()),
                        ),
                      ),
                    ),
                  ),
                  //далее колонки для показа информации о автомобиле
                  Expanded(
                    flex: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(cChars['name'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(cChars['kmage'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(cChars['engine'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(cChars['price'].toString()),
                            margin: const EdgeInsets.symmetric(vertical: 3)),
                        Container(
                          child: Text(cChars['color'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(cChars['drive'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    //кнопка избранное, при нажатии открывает бд и в зависимости от того активна кнопка или нет добавляет ил удаляет данный автомобиль из бд
                    child: StarButton(
                      iconSize: 45,
                      valueChanged: (value) async {
                        if (value as bool) {
                          Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          print('inserted');
                          int raw = await db.rawInsert(
                              'INSERT Into Favs (url)'
                              ' VALUES (?)',
                              [this.cardUrl]);
                          print('ins');
                        } else {
                          Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          db.delete('Favs',
                              where: 'url = ?', whereArgs: [this.cardUrl]);
                          print('del');
                        }
                      },
                    ),
                  ),
                ]),
              ),
            );
          } else {
            //здесь тоже самое, что и для подержаных автомобилей, только ищменены отображаемые характеритики, чтобы сервер и приложение работали корректно.
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
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
              height: MediaQuery.of(context).size.height * 0.15,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CarPage(carUrl: this.cardUrl)))
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    flex: 25,
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CarouselPage(imageUrls: urls),
                          ),
                        )
                      },
                      child: Container(
                        child: Image(
                          image: NetworkImage(
                              'http://' + cChars['images_urls'][0].toString()),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(cChars['name'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(cChars['complectation'].toString()),
                          margin:
                              const EdgeInsets.only(top: 3, bottom: 3, left: 2),
                        ),
                        Container(
                          child: Text(cChars['engine'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(cChars['price'].toString()),
                            margin: const EdgeInsets.symmetric(vertical: 3)),
                        Container(
                          child: Text(cChars['color'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(cChars['drive'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: StarButton(
                      iconSize: 45,
                      valueChanged: (value) async {
                        if (value as bool) {
                          Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          print('inserted');
                          int raw = await db.rawInsert(
                              'INSERT Into Favs (url)'
                              ' VALUES (?)',
                              [this.cardUrl]);
                          print('ins');
                        } else {
                          Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          db.delete('Favs',
                              where: 'url = ?', whereArgs: [this.cardUrl]);
                          print('del');
                        }
                      },
                    ),
                  ),
                ]),
              ),
            );
          }
        });
  }
}

//получает параметры о автомобиле по заданной ссылке
Future<Map<String, dynamic>> getCardParameters(carUrl) async {
  print(carUrl);
  Uri url = Uri.parse('https://autoparseru.herokuapp.com/getCardByUrl');
  //тело запроса
  String body = json.encode({'url': carUrl});
  //сам запрос
  http.Response res = await http.post(url, body: body, headers: headers);
  //проверка если запрос успешен
  if (res.statusCode == 200) {
    //словарь json с ответом сервера
    Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    return jsonRes;
  } else {
    return Map<String, dynamic>();
  }
}
