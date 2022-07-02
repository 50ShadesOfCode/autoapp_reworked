import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'car_card.dart';

List<String> cards = <String>[];

Map<String, String> headers = <String, String>{
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};

//получает с сервера список ссылок на автомобили по ссылке с заданными параметрами
Future<int> _getCarUrls(String purl) async {
  print(purl);
  final Uri url =
      Uri.parse('https://autoparseru.herokuapp.com/getCarsByParams');
  final String body = json.encode(<String, dynamic>{'url': purl});
  final http.Response res = await http.post(url, body: body, headers: headers);
  if (res.statusCode == 200) {
    //создаем список ссылок на картинки на основе массива в ответе сервера
    final Map<String, dynamic> jsonRes =
        json.decode(res.body) as Map<String, dynamic>;
    for (int i = 0; i < (jsonRes['urls'] as List<String>).length; i++) {
      cards.add(jsonRes['urls'][i].toString());
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты'),
      ),
      //FutureBuilder ждет пока выполнится функция, удобно для нашего случая когда у сервера большое время ответа.
      body: FutureBuilder<int>(
        future: _getCarUrls(url),
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
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
