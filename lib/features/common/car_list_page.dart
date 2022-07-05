import 'dart:convert';

import 'package:auto_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'car_card.dart';

List<String> cards = <String>[];

//TODO: Пизда нихуя не работает

//получает с сервера список ссылок на автомобили по ссылке с заданными параметрами
Future<int> _getCarUrls(String purl) async {
  print(purl);
  final Uri url =
      Uri.parse('https://fpmiautoparser.herokuapp.com/getCarsByParams');
  final String body = json.encode(<String, dynamic>{'url': purl});
  final http.Response res = await http.post(url, body: body, headers: headers);
  print(res.statusCode);
  if (res.statusCode == 200) {
    //создаем список ссылок на картинки на основе массива в ответе сервера
    final Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    print('ok');
    for (int i = 0; i < (jsonRes['urls'].length as int); i++) {
      cards.add(jsonRes['urls'][i].toString());
    }
    print('ok');
    print(cards[0]);
    return 200;
  }
  return 404;
}

class CarListPage extends StatefulWidget {
  final String url;
  const CarListPage({required this.url});
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late final String url;

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты'),
      ),
      //FutureBuilder ждет пока выполнится функция, удобно для нашего случая когда у сервера большое время ответа.
      body: FutureBuilder<int>(
        future: _getCarUrls(url),
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            margin: const EdgeInsets.all(5),
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
