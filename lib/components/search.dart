import 'package:auto_app/components/car_list_page.dart';
import 'package:auto_app/utils/url_maker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

//форма поиска сделана при помощи библиотеки flutter_form_builder
class _SearchState extends State<Search> {
  //ключ для обращения к форме
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  Container(
                    child: FormBuilderTextField(
                      name: 'mark',
                      decoration: const InputDecoration(
                        labelText: 'Марка автомобиля',
                      ),
                    ),
                  ),
                  Container(
                    child: FormBuilderTextField(
                      name: 'model',
                      decoration: const InputDecoration(
                        labelText: 'Модель автомобиля',
                      ),
                    ),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                      name: 'body',
                      decoration: const InputDecoration(
                        labelText: 'Кузов',
                      ),
                      allowClear: true,
                      hint: const Text('Выберите кузов'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'SEDAN',
                          child: Text('Седан'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HATCHBACK',
                          child: Text('Хэтчбек'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HATCHBACK_3_DOORS',
                          child: Text('Хэтчбек 3 дв.'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HATCHBACK_5_DOORS',
                          child: Text('Хэтчбек 5 дв.'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'LIFTBACK',
                          child: Text('Лифтбек'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ALLROAD',
                          child: Text('Внедорожник'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ALLROAD_3_DOORS',
                          child: Text('Внедорожник 3 дв.'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ALLROAD_5_DOORS',
                          child: Text('Внедорожник 5 дв.'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'WAGON',
                          child: Text('Универсал'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'COUPE',
                          child: Text('Купе'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'MINIVAN',
                          child: Text('Минивэн'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'PICKUP',
                          child: Text('Пикап'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'LIMOUSINE',
                          child: Text('Лимузин'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'VAN',
                          child: Text('Фургон'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'CABRIO',
                          child: Text('Кабриолет'),
                        ),
                      ],
                      onChanged: print,
                    ),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                      // autovalidate: true,
                      name: 'transmission',
                      decoration: const InputDecoration(
                        labelText: 'Коробка передач',
                      ),
                      allowClear: true,
                      hint: const Text('Выберите вид коробки'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'AUTO',
                          child: Text('Автомат'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'AUTOMATIC',
                          child: Text('Автоматическая'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ROBOT',
                          child: Text('Робот'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'VARIATOR',
                          child: Text('Вариатор'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'MECHANICAL',
                          child: Text('Механическая'),
                        ),
                      ],
                      onChanged: print,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'year_from',
                            decoration: const InputDecoration(
                              labelText: 'Год от',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'year_to',
                            decoration: const InputDecoration(
                              labelText: 'до',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                        name: 'engine_group',
                        decoration: const InputDecoration(
                          labelText: 'Двигатель',
                        ),
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: const Text('Выберите вид двигателя'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'GASOLINE',
                            child: Text('Бензин'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'DIESEL',
                            child: Text('Дизель'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'HYBRID',
                            child: Text('Гибрид'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'ELECTRO',
                            child: Text('Электро'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'TURBO',
                            child: Text('Турбированный'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'ATMO',
                            child: Text('Атмосферный'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'LPG',
                            child: Text('Газобалонное оборудование'),
                          ),
                        ],
                        onChanged: print),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                        name: 'gear_type',
                        decoration: const InputDecoration(
                          labelText: 'Привод',
                        ),
                        allowClear: true,
                        hint: const Text('Выберите вид привода'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'FORWARD_CONTROL',
                            child: Text('Передний'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'REAR_DRIVE',
                            child: Text('Задний'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'ALL_WHEEL_DRIVE',
                            child: Text('Полный'),
                          ),
                        ],
                        onChanged: print),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'km_age_from',
                            decoration: const InputDecoration(
                              labelText: 'Пробег от',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'km_age_to',
                            decoration: const InputDecoration(
                              labelText: 'до',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'displacement_from',
                            decoration: const InputDecoration(
                              labelText: 'Объем от',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'displacement_to',
                            decoration: const InputDecoration(
                              labelText: 'до',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'price_from',
                            decoration: const InputDecoration(
                              labelText: 'Цена от',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'price_to',
                            decoration: const InputDecoration(
                              labelText: 'до',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      'Найти!',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //сохраняем и получаем данные о форме
                      _formKey.currentState?.save();
                      if (_formKey.currentState?.validate() == true) {
                        print(_formKey.currentState?.value);
                        //создаем ссылку на автомобили
                        final String url = makeUrl(_formKey.currentState?.value
                            as Map<String, dynamic>);
                        print(url);
                        //переходим на страницу со списком автомобилей
                        Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  CarListPage(url: url),
                            ));
                      } else {
                        print('validation failed');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                //кнопка сбросить сбрасывает данные формы
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      'Сбросить',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
