import 'dart:convert';

import 'package:auto_app/features/common/carousel.dart';
import 'package:auto_app/features/common/characteristics_page.dart';
import 'package:auto_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//получаем словарь с параметрами автомобиля таким же образом, как и в других функциях
Future<Map<String, dynamic>> getCarParameters(String carUrl) async {
  final Uri url = Uri.parse('https://fpmiautoparser.herokuapp.com/getCarByUrl');
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

Map<String, String> formCharacteristics(
  Map<String, dynamic> chars,
  String type,
) {
  Map<String, String> res = <String, String>{};
  if (type == 'used') {
    res['Наименование'] = chars['name'].toString();
    res['Цена'] = chars['price'].toString();
    res['Год выпуска'] = chars['year'].toString();
    res['Пробег'] = chars['kmage'].toString();

    res['Кузов'] = chars['body'].toString();
    res['Цвет'] = chars['color'].toString();
    res['Двигатель'] = chars['engine'].toString();
    res['Коробка передач'] = chars['transmission'].toString();

    res['Привод'] = chars['drive'].toString();
    res['Руль'] = chars['wheel'].toString();
    res['Состояние'] = chars['state'].toString();
    res['Владельцы'] = chars['owners'].toString();

    res['ПТС'] = chars['pts'].toString();
    res['Таможня'] = chars['customs'].toString();
  } else {
    res['Наименование'] = chars['name'].toString();
    res['Цена'] = chars['price'].toString();
    res['Комплектация'] = chars['complectation'].toString();
    res['Налог'] = chars['tax'].toString();

    res['Кузов'] = chars['body'].toString();
    res['Цвет'] = chars['color'].toString();
    res['Двигатель'] = chars['engine'].toString();
    res['Коробка передач'] = chars['transmission'].toString();

    res['Привод'] = chars['drive'].toString();
    
  }
  return res;
}

class CarPage extends StatefulWidget {
  final String carUrl;
  const CarPage({required this.carUrl});
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  late final String carUrl;

  late final Map<String, String> chars;

  @override
  void initState() {
    carUrl = widget.carUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Информация об автомобиле'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCarParameters(carUrl),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          if (snap.connectionState == ConnectionState.none || !snap.hasData) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[Text('Нет соединения!')],
                ),
              ),
            );
          }
          final Map<String, dynamic> cChars = snap.data as Map<String, dynamic>;
          if (!carUrl.contains('/new/')) {
            chars = formCharacteristics(cChars, 'used');
          } else {
            chars = formCharacteristics(cChars, 'new');
          }
          final List<String> urls = <String>[];
          for (int i = 0; i < (cChars['images_urls'].length as int); i++) {
            urls.add(cChars['images_urls'][i] as String);
          }
          return Scaffold(
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: CarouselWithIndicator(
                            imageUrls: urls,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Характеристики',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final String key = chars.keys.elementAt(index);
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      key,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    flex: 50,
                                  ),
                                  Expanded(
                                    child: Text(
                                      chars[key]!,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    flex: 50,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: const Text(
                            'Комментарий продавца',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            cChars['desc'].toString(),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () => <void>{
                              Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        CharsPage(
                                            url: cChars['chars'].toString())),
                              )
                            },
                            child: const Text('Характеристики автомобиля'),
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () => <void>{_launchURL(carUrl)},
                            child: const Text('Ссылка на источник'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> _launchURL(String _url) async =>
    await canLaunchUrl(Uri.parse(_url))
        ? await launchUrl(Uri.parse(_url))
        : throw 'Could not launch $_url';