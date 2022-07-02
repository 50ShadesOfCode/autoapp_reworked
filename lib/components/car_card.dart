import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_app/components/car_page.dart';
import 'package:auto_app/components/theme_provider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'carousel_page.dart';

class CarCard extends StatefulWidget {
  final String cardUrl;
  const CarCard({required this.cardUrl});
  @override
  _CarCardState createState() => _CarCardState();
}

Map<String, String> headers = <String, String>{
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};

class _CarCardState extends State<CarCard> with AutomaticKeepAliveClientMixin {
  @override
  //нужно для того, чтобы карточки не сбрасывались при обновлении страницы
  bool get wantKeepAlive => true;

  late final String cardUrl;

  @override
  void initState() {
    super.initState();
    cardUrl = widget.cardUrl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getCardParameters(cardUrl),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          final ThemeProvider provider = Provider.of<ThemeProvider>(context);
          //карточка для показа, пока выполняется запрос на сервер
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration: BoxDecoration(
                  color: provider.isDarkMode ? Colors.black : Colors.white,
                  boxShadow: <BoxShadow>[
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
                  boxShadow: <BoxShadow>[
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
          final Map<String, dynamic> cChars =
              snapshot.data as Map<String, dynamic>;
          final List<String> urls = <String>[];
          for (int i = 0;
              i < (cChars['images_urls'] as List<String>).length;
              i++) {
            urls.add('http://' + (cChars['images_urls'] as List<String>)[i]);
          }
          //если на подержаный, то возвращаем карточку для подержаного
          if (!cardUrl.contains('/new/')) {
            return Container(
              //оформление карточки
              decoration: BoxDecoration(
                color: provider.isDarkMode ? Colors.black : Colors.white,
                boxShadow: <BoxShadow>[
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
                                  cChars['images_urls'][0].toString()),
                            ),
                          ),
                        ),
                      ),
                      //далее колонки для показа информации о автомобиле
                      Expanded(
                        flex: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                          children: <Widget>[
                            Container(
                                child: Text(cChars['price'].toString()),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 3)),
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
                          valueChanged: (bool value) async {
                            if (value) {
                              final Directory docsPath =
                                  await getApplicationDocumentsDirectory();
                              final Database db = await openDatabase(
                                  docsPath.path + 'autofavs.db',
                                  version: 1,
                                  onCreate: (Database db, int version) async {
                                await db.execute('CREATE TABLE Favs ('
                                    'url TEXT'
                                    ')');
                              });
                              print('inserted');
                              await db.rawInsert(
                                  'INSERT Into Favs (url)'
                                  ' VALUES (?)',
                                  <Object>[cardUrl]);
                              print('ins');
                            } else {
                              final Directory docsPath =
                                  await getApplicationDocumentsDirectory();
                              final Database db = await openDatabase(
                                  docsPath.path + 'autofavs.db',
                                  version: 1,
                                  onCreate: (Database db, int version) async {
                                await db.execute('CREATE TABLE Favs ('
                                    'url TEXT'
                                    ')');
                              });
                              db.delete('Favs',
                                  where: 'url = ?',
                                  whereArgs: <Object>[cardUrl]);
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
                boxShadow: <BoxShadow>[
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
                onTap: () => <void>{
                  Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              CarPage(carUrl: cardUrl)))
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
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
                      children: <Widget>[
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
                      children: <Widget>[
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
                      valueChanged: (bool value) async {
                        if (value) {
                          final Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          final Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          print('inserted');
                          await db.rawInsert(
                              'INSERT Into Favs (url)'
                              ' VALUES (?)',
                              <Object>[cardUrl]);
                          print('ins');
                        } else {
                          final Directory docsPath =
                              await getApplicationDocumentsDirectory();
                          final Database db = await openDatabase(
                              docsPath.path + 'autofavs.db',
                              version: 1,
                              onCreate: (Database db, int version) async {
                            await db.execute('CREATE TABLE Favs ('
                                'url TEXT'
                                ')');
                          });
                          db.delete('Favs',
                              where: 'url = ?', whereArgs: <Object>[cardUrl]);
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
Future<Map<String, dynamic>> getCardParameters(String carUrl) async {
  print(carUrl);
  final Uri url = Uri.parse('https://autoparseru.herokuapp.com/getCardByUrl');
  //тело запроса
  final String body = json.encode(<String, dynamic>{'url': carUrl});
  //сам запрос
  final http.Response res = await http.post(url, body: body, headers: headers);
  //проверка если запрос успешен
  if (res.statusCode == 200) {
    //словарь json с ответом сервера
    final Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    return jsonRes;
  } else {
    return <String, dynamic>{};
  }
}
