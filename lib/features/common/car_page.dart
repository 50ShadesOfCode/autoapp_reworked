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

class CarPage extends StatefulWidget {
  final String carUrl;
  const CarPage({required this.carUrl});
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  late final String carUrl;

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
          final List<String> urls = <String>[];
          for (int i = 0;
              i < (cChars['images_urls'] as List<String>).length;
              i++) {
            urls.add((cChars['images_urls'] as List<String>)[i]);
          }
          //создание идет по такому же принципу как и карточка, только здесь добавляется
          //карусель с картинками, кнопки для характеристик и обратной связи. Также делится
          //на новые и подержаные
          if (!carUrl.contains('/new/')) {
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
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Наименование',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['name'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Цена',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['price'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Год выпуска',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['year'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Пробег',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['kmage'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Кузов',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['body'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Цвет',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['color'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Двигатель',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['engine'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Коробка передач',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['transmission'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Привод',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['drive'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Руль',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['wheel'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Состояние',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['state'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Владельцы',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['owners'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'ПТС',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['pts'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Таможня',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['customs'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
          } else {
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
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Кузов',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['body'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Цвет',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['color'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Двигатель',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['engine'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Коробка передач',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['transmission'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Привод',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['drive'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Налог',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['tax'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text(
                                          'Комплектация',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars['complectation'].toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Future<void> _launchURL(String _url) async =>
    await canLaunchUrl(Uri.parse(_url))
        ? await launchUrl(Uri.parse(_url))
        : throw 'Could not launch $_url';
