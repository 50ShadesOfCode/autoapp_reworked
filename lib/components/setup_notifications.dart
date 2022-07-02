import 'dart:convert';

import 'package:auto_app/utils/url_maker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotiChars extends StatefulWidget {
  @override
  _NotiChars createState() => _NotiChars();
}

//Характеристики по которым отправляются уведомления. Код по большей части идентичен с кодом поиска, если только пару моментов.
class _NotiChars extends State<NotiChars> {
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
                        // valueTransformer: (text) => num.tryParse(text),
                        //validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(context),
                        //FormBuilderValidators.max(context, 70),
                        //]),
                      ),
                    ),
                    Container(
                      child: FormBuilderTextField(
                        name: 'model',
                        decoration: const InputDecoration(
                          labelText: 'Модель автомобиля',
                        ),
                        // valueTransformer: (text) => num.tryParse(text),
                        //validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(context),
                        //FormBuilderValidators.max(context, 70),
                        //]),
                      ),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                        // autovalidate: true,
                        name: 'body',
                        decoration: const InputDecoration(
                          labelText: 'Кузов',
                        ),
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: const Text('Выберите кузов'),
                        /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
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
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: const Text('Выберите вид коробки'),
                        /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
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
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context)//FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'year_to',
                              decoration: const InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                        // autovalidate: true,
                        name: 'engine_group',
                        decoration: const InputDecoration(
                          labelText: 'Двигатель',
                        ),
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: const Text('Выберите вид двигателя'),
                        /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
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
                        onChanged: print,
                      ),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                          // autovalidate: true,
                          name: 'gear_type',
                          decoration: const InputDecoration(
                            labelText: 'Привод',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: const Text('Выберите вид привода'),
                          /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
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
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'km_age_to',
                              decoration: const InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
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
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'displacement_to',
                              decoration: const InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
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
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'price_to',
                              decoration: const InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
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
                    //при нажатии создает новую ссылку по заданным параметрам
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Text(
                        'Сохранить',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _formKey.currentState?.save();
                        if (_formKey.currentState?.validate() == true) {
                          print(_formKey.currentState?.value);
                          //создает
                          final String url = makeUrl(_formKey
                              .currentState?.value as Map<String, dynamic>);
                          print(url);
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          //сохраняет в SharedPreferences
                          prefs.setString('noturl', url);
                          //выполняет запрос на сервер для получения числа автомобилей
                          final http.Response res = await http.post(
                            Uri.parse(
                                'https://autoparseru.herokuapp.com/getNotUpdate'),
                            body: json.encode(<String, dynamic>{'url': url}),
                            headers: headers,
                          );
                          //сохраняет число автомобилей в SharedPreferences
                          prefs.setString('carups', res.body);
                        } else {
                          print('validation failed');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
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
        ));
  }
}

//Заголовки, есть в каждом файле с запросами
Map<String, String> headers = <String, String>{
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};
