import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'carCard.dart';

List<String> cards = [];

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};

//получает с сервера список ссылок на автомобили по ссылке с заданными параметрами
Future<int> _getCarUrls(String purl) async {
  print(purl);
  var url = Uri.parse("https://autoparseru.herokuapp.com/getCarsByParams");
  var body = json.encode({"url": purl});
  var res = await http.post(url, body: body, headers: headers);
  if (res.statusCode == 200) {
    //создаем список ссылок на картинки на основе массива в ответе сервера
    Map<String, dynamic> jsonRes = json.decode(res.body);
    for (int i = 0; i < jsonRes["urls"].length; i++) {
      cards.add(jsonRes["urls"][i].toString());
    }
    return 200;
  }
  return 404;
}

class CarListPage extends StatefulWidget {
  final String url;
  CarListPage({required String url}) : this.url = url;
  @override
  _CarListPageState createState() => _CarListPageState(url);
}

class _CarListPageState extends State<CarListPage> {
  _CarListPageState(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты'),
      ),
      //FutureBuilder ждет пока выполнится функция, удобно для нашего случая когда у сервера большое время ответа.
      body: FutureBuilder(
        future: _getCarUrls(this.url),
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          return Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CarCard(
                          cardUrl: cards[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
