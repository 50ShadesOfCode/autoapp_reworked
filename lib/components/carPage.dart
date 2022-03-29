import 'dart:convert';

import 'package:auto_app/components/carousel.dart';
import 'package:auto_app/components/charsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};

//получаем словарь с параметрами автомобиля таким же образом, как и в других функциях
Future<Map<String, dynamic>> getCarParameters(carUrl) async {
  var url = Uri.parse("https://autoparseru.herokuapp.com/getCarByUrl");
  var body = json.encode({"url": carUrl});
  var res = await http.post(url, body: body, headers: headers);
  if (res.statusCode == 200) {
    Map<String, dynamic> jsonRes = json.decode(res.body);
    return jsonRes;
  } else {
    return Map<String, dynamic>();
  }
}

class CarPage extends StatefulWidget {
  final String carUrl;
  CarPage({required String carUrl}) : this.carUrl = carUrl;
  @override
  _CarPageState createState() => _CarPageState(carUrl);
}

class _CarPageState extends State<CarPage> {
  _CarPageState(this.carUrl);
  final String carUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Информация об автомобиле'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCarParameters(this.carUrl),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  children: [Text("Нет соединения!")],
                ),
              ),
            );
          }
          Map<String, dynamic> cChars = snap.data as Map<String, dynamic>;
          List<String> urls = [];
          for (int i = 0; i < cChars["images_urls"].length; i++) {
            urls.add(cChars["images_urls"][i]);
          }
          //создание идет по такому же принципу как и карточка, только здесь добавляется
          //карусель с картинками, кнопки для характеристик и обратной связи. Также делится
          //на новые и подержаные
          if (!this.carUrl.contains("/new/"))
            return Scaffold(
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: CarouselWithIndicator(
                              imageUrls: urls,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Характеристики",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Наименование",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["name"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Цена",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["price"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Год выпуска",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["year"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Пробег",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["kmage"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Кузов",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["body"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Цвет",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["color"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Двигатель",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["engine"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Коробка передач",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["transmission"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Привод",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["drive"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Руль",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["wheel"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Состояние",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["state"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Владельцы",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["owners"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "ПТС",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["pts"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Таможня",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["customs"].toString(),
                                          style: TextStyle(color: Colors.black),
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
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Комментарий продавца",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              cChars["desc"].toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CharsPage(
                                          url: cChars["chars"].toString())),
                                )
                              },
                              child: Text("Характеристики автомобиля"),
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () => {_launchURL(this.carUrl)},
                              child: Text("Ссылка на источник"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          else
            return Scaffold(
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: CarouselWithIndicator(
                              imageUrls: urls,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Характеристики",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Кузов",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["body"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Цвет",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["color"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Двигатель",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["engine"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Коробка передач",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["transmission"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Привод",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["drive"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Налог",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["tax"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        flex: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Комплектация",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        flex: 50,
                                      ),
                                      Expanded(
                                        child: Text(
                                          cChars["complectation"].toString(),
                                          style: TextStyle(color: Colors.black),
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
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Комментарий продавца",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              cChars["desc"].toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CharsPage(
                                          url: cChars["chars"].toString())),
                                )
                              },
                              child: Text("Характеристики автомобиля"),
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () => {_launchURL(this.carUrl)},
                              child: Text("Ссылка на источник"),
                            ),
                          ),
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

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
