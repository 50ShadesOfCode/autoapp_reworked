import 'package:auto_app/features/characteristics/bloc/characteristics_bloc.dart';
import 'package:auto_app/features/characteristics/characteristics_page.dart';
import 'package:auto_app/features/common/carousel.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO: Move to  apiprovider, add new
Map<String, String> formCharacteristics(
  Map<String, dynamic> chars,
  String type,
) {
  final Map<String, String> res = <String, String>{};
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
  final Car car;
  const CarPage({required this.car});
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  late Car car;

  late Map<String, String> chars;

  @override
  void initState() {
    car = widget.car;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (car.used) {
      chars = formCharacteristics(car.characteristics, 'used');
    } else {
      chars = formCharacteristics(car.characteristics, 'new');
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Информация об автомобиле'),
      ),
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
                      imageUrls: car.images,
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
                    height: chars.keys.length * 20,
                    child: ListView.builder(
                      itemCount: chars.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String key = chars.keys.elementAt(index);
                        return Container(
                          height: 20,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: <Widget>[
                              Text(
                                key,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                chars[key]!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      },
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
                      car.characteristics['desc'].toString(),
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
                                BlocProvider<CharacteristicsBloc>(
                              create: (BuildContext context) =>
                                  CharacteristicsBloc(
                                apiProvider: appLocator.get<ApiProvider>(),
                              )..add(LoadCharsEvent(
                                      url: car.characteristics['chars']
                                          as String,
                                    )),
                              child: CharsPage(),
                            ),
                          ),
                        )
                      },
                      child: const Text('Характеристики автомобиля'),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () => <void>{_launchURL(car.url)},
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
  }
}

Future<void> _launchURL(String _url) async =>
    await canLaunchUrl(Uri.parse(_url))
        ? await launchUrl(Uri.parse(_url))
        : throw 'Could not launch $_url';
